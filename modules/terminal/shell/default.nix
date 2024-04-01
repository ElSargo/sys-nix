{pkgs, ...}: {
  users.defaultUserShell = pkgs.nushellFull;
  home-manager.sharedModules = [
    ({config, ...}: {
      imports = [
        ./bash.nix
        ./completion.nix
        ./fish.nix
        ./shell_aliases.nix
        ./task.nix
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
        nixfmt
        typos
        pastel
        cargo
      ];

      programs.nushell = {
        enable = true;
        configFile.text =
          # nu
          ''
            $env.DIR_STACK = [ $env.PWD ]
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
              hooks: {
                  env_change: {
                     PWD: {|before, after| $env.DIR_STACK = ( $env.DIR_STACK | append $after); }
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
              try {
                $env.DIR_STACK = ( $env.DIR_STACK | drop )
                cd ( $env.DIR_STACK | last )
                $env.DIR_STACK = ( $env.DIR_STACK | drop )
              } catch {
                print "No previous dir to jump to"
              }
            }

            def rb [ opp ] {
              print Building system...
              let name = (sys | get host.hostname )
              cd ~/sys-nix/
              git diff
              git add -A
              git commit -m $"SYSTEM REBUILD ( date now )"
              sudo nixos-rebuild $opp --flake ( $"~/sys-nix#($name)" | path expand ) -p $name
              ${pkgs.libnotify}/bin/notify-send $"Rebuild complete: ($name)"
            }
          '';
        shellAliases = config.shellAliases // {lf = " cd ( ${pkgs.lf}/bin/lf -print-last-dir )";};
      };
    })
  ];
}
