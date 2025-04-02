{pkgs, ...}: {
  programs.nushell = {
    package = pkgs.unstable.nushell;
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
                 PWD: [{|before, after| if $env.DIR_STACK.changed_by_bd {
                    $env.DIR_STACK.changed_by_bd = false;
                  } else {
                    push_dir $after
                  }
                }]
              }
          }
        }
        $env.PATH = ($env.PATH | split row (char esep) | append "~/.cargo/bin")
        $env.DIRENV_LOG_FORMAT = ""
        $env.EDITOR = "hx"
        $env.VISUAL = "hx"

        def bat-mode [] {
          cd /sys/devices/platform/msi-ec
          echo on | sudo tee super_battery
          echo eco | sudo tee shift_mode
          echo silent | sudo tee fan_mode
        }

        def perf-mode [] {
          cd /sys/devices/platform/msi-ec
          echo off | sudo tee super_battery
          echo sport | sudo tee shift_mode
          echo auto | sudo tee fan_mode
        }

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
    shellAliases = {
      q = "exit";
      ":q" = "exit";
      c = "clear";
      r = "reset";
    };
  };
}
