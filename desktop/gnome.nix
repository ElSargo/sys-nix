{ pkgs, ... }: {
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  environment = {
    gnome.excludePackages = with pkgs.gnome;
      [
        cheese # webcam tool
        gnome-music
        gnome-terminal
        gedit # text editor
        epiphany # web browser
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ] ++ [ pkgs.gnome-tour ];
    systemPackages = with pkgs.gnomeExtensions; [
      removable-drive-menu
      caffeine
      dash-to-dock
      blur-my-shell
      uptime-indicator
      coverflow-alt-tab
      grand-theft-focus
    ];
  };
}
