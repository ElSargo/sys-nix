{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./network.nix
    ./power-management.nix
    ./remaps.nix
    ./settings.nix
    ./dark-theme.nix
    ./desktop-programs.nix
    ./firefox.nix
    ./kitty.nix
    ./mime.nix
    ./gnome.nix
  ];

  services.preload.enable = true;
}
