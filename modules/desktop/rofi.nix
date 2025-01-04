{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      programs.rofi = {
        enable = true;
        terminal = "${pkgs.wezterm}/bin/wezterm start";
      };
    })
  ];
}
