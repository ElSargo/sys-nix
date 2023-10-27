{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./gnome.nix
    ./network.nix
    ./power-management.nix
    ./remaps.nix
    ./settings.nix
  ];

  users.defaultUserShell = pkgs.unstable.fish;
  system.stateVersion = "23.05";
}
