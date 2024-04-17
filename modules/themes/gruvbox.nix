{
  config,
  pkgs,
  ...
}: {
  theme = config.mkTheme "gruvbox-dark-medium";
  wallpaper = pkgs.fetchurl {
    url = "https://codeberg.org/exorcist/wallpapers/raw/commit/7f2d29df30958703bc3c3fe1e20eb2e5a0ccaf22/abstract-2.jpg";
    sha256 = "sha256-MfXswI2VqCxb5Q/67bEqxJeibSJ5bk1FlcMTgln7Zqo=";
  };

  stylix.autoEnable = false;
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      # stylix.autoEnable = false;
      # stylix.targets.wezterm.enable = true;
      # stylix.targets.nushell.enable = true;
      # stylix.targets.fish.enable = true;
      # stylix.targets.bat.enable = true;
      programs.helix.settings.theme = "gruvy";
      programs.helix.themes = {
        gruvy = {
          inherits = "gruvbox";
          "ui.background" = {
            fg = "foreground";
            bg = "background";
          };

          "comment" = {
            fg = "gray1";
            modifiers = ["italic"];
          };
          "keyword" = {
            fg = "red1";
            modifiers = ["italic"];
          };
          "keyword.function" = {
            fg = "red1";
            modifiers = ["italic"];
          };
          "markup.italic" = {modifiers = ["italic"];};
          "markup.quote" = {modifiers = ["italic"];};
        };
      };
    })
  ];
}
