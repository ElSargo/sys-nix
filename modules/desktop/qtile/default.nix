{
  pkgs,
  inputs,
  ...
}: let
  geckordp = import ./geckordp.nix;
  extraQtilePackages = [
    (inputs.wezpy.packages.${pkgs.system}.default pkgs.python311Packages)
    pkgs.python311Packages.qtile-extras
    (geckordp pkgs.python311Packages)
  ];
  interpreter = pkgs.python311.withPackages (pypkgs: with pypkgs; [qtile python-lsp-server pyflakes rope] ++ extraQtilePackages);
  lsp =
    pkgs.writeScriptBin "pylsp"
    ''
      #! ${interpreter}/bin/python
      from pylsp.__main__ import main
      import sys
      sys.exit(main())
    '';
in {
  environment.systemPackages =
    [(pkgs.python311Packages.qtile.override {extraPackages = extraQtilePackages;})]
    ++ (with pkgs; [lsp swayosd swaynotificationcenter brightnessctl blueberry wdisplays]);

  programs.ydotool.enable = true;

  services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness" ACTION=="add", SUBSYSTEM=="backlight", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"'';
  services.gnome.gnome-keyring.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    config = {
      common = {
        default = [
          "wlr"
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = let
      command = "qtile start -b wayland";
    in {
      initial_session = {
        user = "sargo";
        inherit command;
      };

      default_session = {
        user = "sargo";
        command = "bash";
      };
    };
  };

  home-manager.sharedModules = [
    (
      {config, ...}: {
        xdg.configFile."qtile/config.py".source = config.lib.file.mkOutOfStoreSymlink "/home/sargo/sys-nix/modules/desktop/qtile/config.py";
      }
    )
  ];
}
