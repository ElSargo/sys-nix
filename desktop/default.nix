{ pkgs, ... }: {
  imports = [
    ./audio.nix
    ./fonts.nix
    ./network.nix
    ./power-management.nix
    ./remaps.nix
    ./settings.nix
  ];

  services.preload.enable = true;
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.unstable.fish;
  system.stateVersion = "23.11";
}
