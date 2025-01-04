{
  networking = {nameservers = ["1.1.1.1" "8.8.8.8"];};
  services = {
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "no";
  };
}
