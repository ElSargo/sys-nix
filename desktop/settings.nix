{ pkgs, ... }: {
  environment = { sessionVariables = { NIXOS_OZONE_WL = "1"; }; };
  xdg.portal = { enable = true; };
  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
  };
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
  services = {
    printing.enable = true;
    flatpak.enable = true;
    syncthing.enable = true;
    xserver = {
      enable = true;
      desktopManager = { xterm.enable = false; };
      libinput.enable = true;
      excludePackages = [ pkgs.xterm ];
      layout = "us";
    };
  };
  systemd.watchdog.rebootTime = "10s";
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';
}
