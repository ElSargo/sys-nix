{
  config,
  lib,
  ...
}: {
  home-manager.sharedModules = lib.mkIf config.gnome.enable [
    ({pkgs, ...}: {
      home.packages = with pkgs.gnomeExtensions; [onedrive];
    })
  ];
  services.onedrive.enable = true;
}
