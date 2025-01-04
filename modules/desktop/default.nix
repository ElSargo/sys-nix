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
    ./wezterm.nix
    ./games.nix
    # ./wayfire.nix
    ./qtile
    ./rofi.nix
  ];

  services.preload.enable = true;
}
