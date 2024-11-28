{
  config,
  pkgs,
  ...
}: {
  config = {
    theme = config.mkTheme "tokyo-night-dark";
    stylix.autoEnable = true;

    wallpaper = pkgs.fetchurl {
      url = "https://unsplash.com/photos/P-yzuyWFEIk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTV8fHNjZW5lcnl8ZW58MHx8fHwxNzExOTQ4MDk4fDA&force=true";
      hash = "sha256-OX4Cykle4Rd7gYRRxE92CXAXpdAhpPUeXLNmMzP2+tI=";
    };


  home-manager.sharedModules = [
    ({pkgs, lib, ...}: {
      programs.helix.settings.theme = lib.mkForce "tok";
      programs.helix.themes = {
        tok= {
          inherits = "tokyonight";
          "ui.background" = {
            fg = "foreground";
            bg = "background";
          };

          "comment" = {
            modifiers = ["italic"];
          };
          "keyword" = {
            modifiers = ["italic"];
          };
          "keyword.function" = {
            modifiers = ["italic"];
          };
          "markup.italic" = {modifiers = ["italic"];};
          "markup.quote" = {modifiers = ["italic"];};
        };
      };

    })];
    
  };
}
