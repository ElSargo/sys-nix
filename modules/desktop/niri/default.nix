{
  programs.niri.enable = true;
  services.upower.enable = true;
  home-manager.sharedModules = [
    ({
      config,
      pkgs,
      ...
    }: {
      home.packages = with pkgs.unstable; [anyrun swaynotificationcenter swayosd hyprpicker blueberry];
      xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "/home/sargo/sys-nix/modules/desktop/niri/config.kdl";
    })
  ];
}
