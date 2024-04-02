{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      programs.wezterm.enable = true;
    })
  ];
}
