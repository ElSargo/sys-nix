{pkgs, ...}: {
  users.defaultUserShell = pkgs.unstable.nushell;
  home-manager.sharedModules = [
    ({config, ...}: {
      imports = [
        ./bash.nix
        ./fish.nix
        ./shell_aliases.nix
        ./task.nix
        ./prompt.nix
      ];

      home.packages = with pkgs; [
        ripgrep
        wl-clipboard
        unzip
        eza
        wget
        trash-cli
        delta
        htop
        typos
        pastel
        cargo
      ];

      programs.carapace.enable = true;
      programs.carapace.enableNushellIntegration = false;

      programs.nushell = {
        package = pkgs.unstable.nushell; # Nu shell 0.91 is broken with carapace
        enable = true;
        configFile.text =
          # nu
          ''
            $env.DIR_STACK = {
              stack: [ $env.PWD ],
              level: 0,
              changed_by_bd: false
            }

            def --env push_dir [dir] {
              let level = $env.DIR_STACK.level + 1;
              $env.DIR_STACK.level = $level
              if $level < ( $env.DIR_STACK.stack | length ) {
                $env.DIR_STACK.stack = ($env.DIR_STACK.stack | update $level $dir)
              } else {
                $env.DIR_STACK.stack = ($env.DIR_STACK.stack | append $dir)
              }
            }

            let carapace_completer = {|spans: list<string>|
                carapace $spans.0 nushell ...$spans
                | from json
                | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
            }

            let zoxide_completer = {|spans|
              zoxide query -l --exclude $env.PWD | lines | where {|x| $x =~ $spans.1}
            }

            # This completer will use carapace by default
            let external_completer = {|spans|
                let expanded_alias = scope aliases
                | where name == $spans.0
                | get -i 0.expansion

                let spans = if $expanded_alias != null {
                    $spans
                    | skip 1
                    | prepend ($expanded_alias | split row ' ' | take 1)
                } else {
                    $spans
                }

                match $spans.0 {
                    __zoxide_z | __zoxide_zi => $zoxide_completer
                    _ => $carapace_completer
                } | do $in $spans
            }


            $env.config = {
              table: {
                mode: rounded
              }
              show_banner: false,
              ls: {
                use_ls_colors: true
                clickable_links: true
              }
              rm: {
                always_trash: true
              }
              completions: {
                  external: {
                      enable: true
                      completer: $external_completer
                  }
              }
              hooks: {
                  env_change: {
                     PWD: {|before, after| if $env.DIR_STACK.changed_by_bd {
                        $env.DIR_STACK.changed_by_bd = false;
                      } else {
                        push_dir $after
                      }
                    }
                  }
                  command_not_found: {
                      |cmd| (
                         let foundCommands = (nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root ("/bin/" + $cmd) | lines | str replace ".out" "");
                         if ($foundCommands | length) == 0  {
                           print "Command not found"
                        } else if $cmd != "wl-copy" {
                            print "Command is avalible in the following packages"
                            print $foundCommands
                            print ("nix-shell -p " + $foundCommands.0 + " coppied to clipboard")
                            echo ("nix-shell -p " + ($foundCommands | get 0) )| wl-copy;
                        }
                      )
                  }
              }
            }
            $env.PATH = ($env.PATH | split row (char esep) | append "~/.cargo/bin")
            $env.DIRENV_LOG_FORMAT = ""
            $env.EDITOR = "hx"
            $env.VISUAL = "hx"


            def --env bd [] {
              let level = ( [($env.DIR_STACK.level - 1) 0] | math max )
              $env.DIR_STACK.level = $level
              $env.DIR_STACK.changed_by_bd = true
              cd ($env.DIR_STACK.stack | get $env.DIR_STACK.level)
            }

            def --env nd [] {
              $env.DIR_STACK.changed_by_bd = false
              cd ($env.DIR_STACK.stack | get ($env.DIR_STACK.level + 1))
            }

            def rb [ opp ] {
              print Building system...
              let name = (sys | get host.hostname )
              cd ~/sys-nix/
              try {
                git diff
                git add -A
                git commit -m $"SYSTEM REBUILD ( date now )"
              }
             sudo nixos-rebuild $opp --flake ( $"~/sys-nix#($name)" | path expand ) -p $name
              ${pkgs.libnotify}/bin/notify-send $"Rebuild complete: ($name)"
            }

            def --env y [...args] {
            	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            	${pkgs.yazi}/bin/yazi ...$args --cwd-file $tmp
            	let cwd = (open $tmp)
            	if $cwd != "" and $cwd != $env.PWD {
            		cd $cwd
            	}
            	rm -fp $tmp
            }

          '';
        shellAliases = config.shellAliases // {lf = " cd ( ${pkgs.lf}/bin/lf -print-last-dir )";};
      };
    })
  ];
}
