{lib, ...}: {
  options.palettes.tokionight = lib.mkOption {
    default = rec {
      helix_theme = "tokio";
      aqua = "#89ddff";
      bg = "#16161e"; # main background
      bg2 = "#373d5a";
      bg3 = br_bg;
      bg4 = bg3;
      blue = "#7aa2f7";
      br_aqua = "#b4f9f8";
      br_bg = "#1f2335";
      br_blue = "#2ac3de";
      br_gray = "#9aa5ce";
      br_green = "#9ece6a";
      br_orange = br_aqua;
      br_purple = "#bb9af7";
      br_red = red;
      br_yellow = yellow;
      fg = "#a9b1d6";
      br_fg = "#c0caf5"; # main foreground
      fg2 = "#363b54";
      fg3 = br_fg;
      fg4 = br_blue; # gray0
      gray = br_gray;
      green = "#73daca";
      orange = "#ff9e64";
      purple = "#7dcfff";
      red = "#f7768e";
      tan = blue;
      white = "#c0caf5";
      yellow = "#e0af68";
    };
  };
}
