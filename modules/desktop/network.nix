{
  networking = {
    networkmanager.enable = true;
    stevenblack = {
      block = ["fakenews" "gambling" "porn"];
      enable = false;
    };
    firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
        {
          from = 21115;
          to = 21117;
        }
      ];
      allowedUDPPorts = [
        21116
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        } # KDE Connect
      ];
    };
  };
}
