{ pkgs, config, ... }: {
    programs.kitty = {
      enable = true;
      package = pkgs.unstable.kitty;
      # theme  = "Gruvbox Dark";
      settings = {
        font_family = "JetbrainsMono Nerd Font";
        update_check_interval = 0;
        hide_window_decorations = "yes";
        resize_in_steps = "yes";
        confirm_os_window_close = 0;
        remember_window_size = "yes";
        background_opacity = "0.85";
        allow_remote_control = "yes";
        map = "ctrl+shift+enter new_os_window_with_cwd";
        font_size = 13;

        # theme  = "Gruvbox Dark";
        selection_foreground = config.palette.fg; # "#ebdbb2"
        selection_background = config.palette.br_orange; # "#d65d0e"

        background = config.palette.bg; # "#282828"
        foreground = config.palette.fg; # "#ebdbb2"

        color0 = config.palette.br_bg; # "#3c3836"
        color1 = config.palette.red; # "#cc241d"
        color2 = config.palette.green; # "#98971a"
        color3 = config.palette.yellow; # "#d79921"
        color4 = config.palette.blue; # "#458588"
        color5 = config.palette.purple; # "#b16286"
        color6 = config.palette.aqua; # "#689d6a"
        color7 = config.palette.fg2; # "#a89984"
        color8 = config.palette.br_red; # "#928374"
        color9 = config.palette.br_green; # "#fb4934"
        color10 = config.palette.br_yellow; # "#b8bb26"
        color11 = config.palette.br_blue; # "#fabd2f"
        color12 = config.palette.br_purple; # "#83a598"
        color13 = config.palette.br_aqua; # "#d3869b"
        color14 = config.palette.white; # "#8ec07c"
        color15 = config.palette.tan; # "#fbf1c7"

        cursor = config.palette.fg2; # "#bdae93"
        cursor_text_color = config.palette.bg2; # "#665c54"

        url_color = config.palette.br_blue; # "#458588"

      };
    };
}
