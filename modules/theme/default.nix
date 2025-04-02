{
  config = {
    stylix.enable = true;
    stylix.image = ./back.png;
    stylix.polarity = "dark";
    boot.plymouth.enable = true;

    home-manager.sharedModules = [
      {
        stylix.enable = true;
        stylix.polarity = "dark";
      }
    ];
  };
}
