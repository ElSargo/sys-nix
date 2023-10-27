{ ... }: {
  # Disable root login
  users.users.root.hashedPassword = "!";
  home-manager.users.root = { lib, ... }: {
    palette = import ../palettes/tokionight.nix;
    imports = [
      ./modules/bash.nix
      ./modules/starship.nix
      ./modules/lf.nix
      ./modules/fish.nix
      ./modules/helix.nix
      ./modules/zellij.nix
      ./modules/zoxide.nix
      ./modules/palettes.nix
    ];
    home.homeDirectory = "/root";
    home.stateVersion = "23.05";
  };
}
