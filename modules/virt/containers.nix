{
  virtualisation.podman.enable = true;
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [distrobox boxbuddy];
    })
  ];
}
