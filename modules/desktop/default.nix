{...}: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./network.nix
    ./power-management.nix
    ./remaps.nix
    ./settings.nix
    ./desktop-programs.nix
    ./firefox.nix
    ./wezterm
    # ./games.nix
    # ./qtile
    ./gnome
    ./wacom.nix
    # ./rofi.nix
  ];

  services.preload.enable = true;
}
