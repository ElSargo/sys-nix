{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./power-management.nix
    ./remaps.nix
    ./settings.nix
    ./desktop-programs.nix
    ./wezterm
    ./gnome
    ./niri
    ./quickshell
  ];

  services.preload.enable = true;
}
