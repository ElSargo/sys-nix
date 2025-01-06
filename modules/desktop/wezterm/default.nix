{
  home-manager.sharedModules = [
    ({
      pkgs,
      config,
      ...
    }: {
      programs.wezterm.enable = true;
      xdg.configFile."wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "/home/sargo/sys-nix/modules/desktop/wezterm/wezterm.lua";
    })
  ];
}
