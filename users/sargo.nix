{
  users.users.sargo = {
    isNormalUser = true;
    initialHashedPassword = "$6$Z7Ty/RzwsUJtd43I$6dCbqpYN1HOhTr5EoEgu6XyctK8lCYu6OqJGzREOjR5L0i6mn12vl2wF.nJzrAxqTCIl5idftqSOPI8WLNVky0";
    description = "Oliver Sargison";
    extraGroups = ["networkmanager" "wheel" "libvirt-qemu" "video"];
  };
  home-manager.users.sargo = {
    browser = "firefox";
    programs = {
      nix-index.enable = true;
      home-manager.enable = true;
    };

    home.username = "sargo";
    home.homeDirectory = "/home/sargo";
    home.stateVersion = "23.11";
  };
}
