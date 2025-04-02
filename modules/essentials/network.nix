{
  networking = {
    networkmanager.enable = true;
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
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
  services = {
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "no";
  };
}
