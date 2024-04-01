{
  pkgs,
  config,
  ...
}:
with builtins; {
  programs.kitty.shellIntegration.enableFishIntegration = true;
  programs.fish = {
    package = pkgs.fish;
    enable = true;
    functions = let
      mk_config = op: {
        argumentNames = ["name"];
        description = "Rebuild the system configuration";
        body =
          # fish
          ''
            if test -z $name
              set name $hostname
            end
            ulimit -n 4096;
            sudo nixos-rebuild ${op} --flake "/home/sargo/sys-nix/#$(echo $name)" -p $name
          '';
      };
    in {
      rbs = mk_config "switch";
      rbb = mk_config "boot";
      copy_history = {
        body =
          # fish
          "history | ${pkgs.skim}/bin/sk | xc";
        description = "Copy a previously run command";
      };
    };
    shellAliases = config.shellAliases // {lf = " cd $( ${pkgs.lf}/bin/lf -print-last-dir )";};
    shellAbbrs = {
      q = "exit";
      ":q" = "exit";
      c = "clear";
      r = "reset";
    };
    shellInit =
      # fish
      ''
        export EDITOR="hx"
        export VISUAL="hx"
      '';
    interactiveShellInit =
      # fish
      let
        color = mapAttrs (k: v: builtins.substring 1 6 v) config.palette;
      in ''
        set fish_greeting
        bind \ce edit_command_buffer
        bind \ch copy_history
        zoxide init fish | source
        starship init fish | source
        set -Ux STARSHIP_LOG error
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        export DIRENV_LOG_FORMAT=
        set fish_color_normal ${color.blue}
        set fish_color_command ${color.blue}
        set fish_color_option ${color.br_yellow}
        set fish_color_escape ${color.br_orange}
        set fish_color_end ${color.br_orange}
        set fish_color_cancel ${color.br_orange}
        set fish_color_redirection ${color.br_orange}
        set fish_color_status ${color.br_red}
        set fish_color_quote ${color.br_green}
        set fish_color_comment ${color.gray}
        set fish_color_keyword ${color.br_red}
        set fish_color_valid_path ${color.br_green}
        set fish_pager_color_progress ${color.br_yellow}
        set fish_pager_color_progress --background ${color.br_bg}
        set fish_pager_color_background --background ${color.br_bg}
        set fish_pager_color_prefix ${color.green}
        set fish_pager_color_completion ${color.br_green}
        set fish_pager_color_description ${color.fg}
        set fish_pager_color_selected_background --background ${color.br_orange}
        set fish_pager_color_selected_prefix ${color.br_bg}
        set fish_pager_color_selected_completion ${color.bg2}
        set fish_pager_color_selected_description ${color.br_bg}
        set fish_pager_color_secondary_background --background ${color.bg2}
        set fish_pager_color_secondary_prefix ${color.green}
        set fish_pager_color_secondary_completion ${color.br_green}
        set fish_pager_color_secondary_description ${color.fg}
      '';

    # NOTE don't use plugins from the nixpkgs repo as they aren't configured properly
    plugins = [
      {
        name = "autopair-fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "colored-man-pages";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "colored_man_pages.fish";
          rev = "f885c2507128b70d6c41b043070a8f399988bc7a";
          sha256 = "ii9gdBPlC1/P1N9xJzqomrkyDqIdTg+iCg0mwNVq2EU=";
        };
      }
      {
        name = "sponge";
        src = pkgs.fetchFromGitHub {
          owner = "meaningful-ooo";
          repo = "sponge";
          rev = "384299545104d5256648cee9d8b117aaa9a6d7be";
          sha256 = "MdcZUDRtNJdiyo2l9o5ma7nAX84xEJbGFhAVhK+Zm1w=";
        };
      }
      {
        name = "x";
        src = pkgs.fetchFromGitHub {
          owner = "Molyuu";
          repo = "x";
          rev = "43dbf864f67c0b548845f30287c42e804cf1fa8c";
          sha256 = "sha256-oYVZoDCmY9zl5pLAKmO8xvMCSAe6vxf+yFpB6o8koos=";
        };
      }
    ];
  };
}
