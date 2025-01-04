{...}: {
  environment = {sessionVariables = {NIXOS_OZONE_WL = "1";};};
  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  services = {
    printing.enable = true;
    flatpak.enable = true;
    libinput.enable = true;
  };
  systemd.watchdog.rebootTime = "10s";
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
    DefaultTimeoutStartSec=10s
  '';
}
