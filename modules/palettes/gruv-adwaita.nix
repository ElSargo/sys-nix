{lib, ...}: {
  options.palettes.gruv-adwaita = lib.mkOption {
    default = {
      helix_theme = "gruvy";
      aqua = "#689d6a";
      fg = "#ffffff";
      fg2 = "#ffffff";
      br_fg = "#ebdbb2"; # main foreground
      bg = "#242424"; # main background
      bg2 = "#454545";
      br_bg = "#303030";
      blue = "#458588";
      br_aqua = "#8ec07c";
      br_blue = "#83a598";
      br_gray = "#928374";
      br_green = "#b8bb26";
      br_orange = "#fe8019";
      br_purple = "#d3869b";
      br_red = "#fb4934";
      br_yellow = "#fabd2f";
      gray = "#363636";
      green = "#98971a";
      orange = "#d65d0e";
      purple = "#b16286";
      red = "#cc241d";
      white = "#ffffff";
      yellow = "#d79921";
    };
  };
}
