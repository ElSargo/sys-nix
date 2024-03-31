{ pkgs, config, ... }: {
  programs.starship = let
    bg = config.palette.br_bg;
    sep = config.palette.bg2;

  in {
    enable = true;
    package = pkgs.unstable.starship;
    settings = let
      main_format = builtins.concatStringsSep
        "[](fg:${bg} bg:${sep})[](fg:${sep} bg:${bg})" [
          "[](fg:${bg})[ ](bg:${bg} fg:${config.palette.br_blue})"
          "$shell$shlvl"
          "$time"
          "$directory"
          "$git_branch$git_metrics$git_status"
          "$nix_shell"
          "$rust"
          "$cmd_duration"
        ];
    in {
      format = ''
         ${main_format}[](fg:${bg})
        $jobs$character'';

      palette = "gruvbox";
      directory = {
        format =
          "[ $path](bg:${bg} fg:${config.palette.br_yellow})[$read_only](bg:${bg})";
        substitutions = {
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "nix-files" = " ";
          "~/projects" = " ";
        };
      };
      shell = {
        disabled = false;
        bash_indicator = " ";
        fish_indicator = "󰈺 ";
        zsh_indicator = "󰫫 ";
        powershell_indicator = "󰨊 ";
        nu_indicator = "󰟆 ";
        unknown_indicator = "?";
        ion_indicator = " ";
        elvish_indicator = "λ";
        style = "bg:${bg} fg:${config.palette.br_orange}";
        format = "[ $indicator]($style)";
      };
      shlvl = {
        disabled = false;
        symbol = " ";
        style = "bg:${bg}";
        format = "[$symbol$shlvl]($style)";

      };
      git_branch = {
        style = "bg:${bg} fg:${config.palette.br_blue}";
        format = "[ $symbol$branch($remote_branch)]($style)";
      };
      git_status = {
        style = "bg:${bg} fg:${config.palette.br_orange}";
        format = "[ \\[$all_status$ahead_behind\\]]($style)";
      };
      git_metrics = {
        disabled = false;
        format =
          "[ +$added ](bg:${bg} fg:${config.palette.br_green})[-$deleted](bg:${bg} fg:${config.palette.br_red})";
      };
      rust.format =
        "[ $symbol($version)](fg:${config.palette.br_orange} bg:${bg})";
      time = {
        disabled = false;
        use_12hr = true;
        format = "[ $time](bg:${bg} fg:${config.palette.br_green})";
        time_format = "%I:%M %p";
      };
      cmd_duration = {
        format = "[ took](bg:${bg})[ $duration]($style)";
        style = "bg:${bg} fg:${config.palette.br_purple}";
      };
      nix_shell = {
        format = "[   $state shell](fg:${config.palette.br_blue} bg:${bg})";
      };
      palettes = {
        gruvbox = {
          bg = "${config.palette.bg}"; # main background
          br_bg = "${bg}";
          bg2 = "${sep}";
          fg = "${config.palette.fg}";
          br_fg = "${config.palette.br_fg}"; # main foreground
          fg2 = "${config.palette.fg2}";
          gray = "${config.palette.gray}";
          br_gray = "${config.palette.br_gray}";
          red = "${config.palette.red}";
          br_red = "${config.palette.br_red}"; # bright
          green = "${config.palette.green}";
          br_green = "${config.palette.br_green}";
          yellow = "${config.palette.yellow}";
          br_yellow = "${config.palette.br_yellow}";
          blue = "${config.palette.blue}";
          br_blue = "${config.palette.br_blue}";
          purple = "${config.palette.purple}";
          br_purple = "${config.palette.br_purple}";
          aqua = "${config.palette.aqua}";
          br_aqua = "${config.palette.br_aqua}";
          orange = "${config.palette.orange}";
          br_orange = "${config.palette.br_orange}";

        };
      };
    };
  };
}
