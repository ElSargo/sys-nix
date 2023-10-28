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
  };
}
