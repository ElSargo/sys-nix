{
  networking = { nameservers = [ "192.168.1.1" "1.1.1.1" "8.8.8.8" ]; };
  services = {
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "no";
  };
}
