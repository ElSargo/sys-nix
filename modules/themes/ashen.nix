{...}: {
  config = {
    theme = ./hex_steel.yaml;
    stylix = {
      polarity = "dark";
      autoEnable = true;
      targets.grub = {
        enable = true;
        useImage = true;
      };
    };

    boot.plymouth.enable = true;
    wallpaper = /home/sargo/Pictures/Background.jpg;
  };
}
