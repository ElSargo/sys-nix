{config, ...}: {
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword = "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = ["networkmanager" "wheel" "libvirt-qemu"];
  };
  security.sudo.extraRules = [
    {
      users = ["sargo"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  home-manager.users.sargo = {lib, ...}: {
    # palette = config.palettes.gruv-adwaita;
    browser = "firefox";
    programs = {
      nix-index.enable = true;
      home-manager.enable = true;
      lazygit = {
        enable = true;
        settings = {
          git = {
            autofetch = true;
            paging = {
              colorarg = "always";
              colorArg = "always";
              pager =
                # bash
                "delta --dark --paging=never --24-bit-color=never";
            };
          };
        };
      };

      direnv = {
        nix-direnv.enable = true;
        enable = true;
      };
      git = {
        enable = true;
        userName = "Oliver Sargison";
        userEmail = "sargo@sargo.cc";
        delta.enable = true;
      };
      bash = {enable = true;};
    };

    # services.pueue.enable = true;
    home.username = "sargo";
    home.homeDirectory = "/home/sargo";
    home.stateVersion = "23.11";
  };
}
