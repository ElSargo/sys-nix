{ config, ... }: {
  # Disable root login
  users.users.root.hashedPassword = "!";
  home-manager.users.root = { lib, ... }: {
    palette = config.palettes.tokionight;
    home.homeDirectory = "/root";
    home.stateVersion = "23.11";
  };
}
