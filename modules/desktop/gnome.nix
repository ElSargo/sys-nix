{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {gnome.enable = lib.mkOption {default = true;};};

  config = lib.mkIf config.gnome.enable {
    programs.fuse.userAllowOther = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.gnome.sushi.enable = true;
    services.gnome.gnome-browser-connector.enable = true;
    environment = {
      systemPackages = with pkgs; [valent];
      gnome.excludePackages = with pkgs;
        [
          cheese # webcam tool
          gnome-music
          gnome-terminal
          # gedit # text editor
          epiphany # web browser
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
        ]
        ++ [pkgs.gnome-tour];
    };

    home-manager.sharedModules = [
      ({
        pkgs,
        lib,
        ...
      }: let
        extensions = with pkgs.gnomeExtensions; [
          caffeine
          # rounded-window-corners
          just-perfection
        ];
      in {
        home.packages = extensions;

        dconf.settings = with builtins;
        with lib; let
          binds = [
            {
              binding = "<Super>Return";
              command = "wezterm";
              name = "open-terminal";
            }
            {
              binding = "<Super><Shift>p";
              command = "xdg-open https://search.nixos.org/";
              name = "package-search";
            }
            {
              binding = "<Super>f";
              command = "nautilus";
              name = "files";
            }
          ];
          mkreg = imap (i: v: "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${
            toString (i - 1)
          }/");
          mkbinds = binds:
            foldl' (a: b: a // b) {} (imap
              (i: v: {
                "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${
                  toString (i - 1)
                }" =
                  v;
              })
              binds);
          addNum = s: x: s + (toString x);
          wkb = a: s1: s2: x: setAttr a (addNum s1 x) [(addNum s2 x)];
          workspace_binds =
            foldl'
            (a: x: (wkb (wkb a "switch-to-workspace-" "<Super>" x)
              "move-to-workspace-" "<Shift><Super>"
              x))
            {}
            (range 1 10);
        in
          (mkbinds binds)
          // {
            "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
              mkreg binds;
            "org/gnome/desktop/wm/keybindings" =
              workspace_binds
              // {
                switch-applications = ["<Super>Tab"];
                switch-applications-backward = ["<Super><Shift>Tab"];
                switch-windows = ["<Alt>Tab"];
                switch-windows-backward = ["<Alt><Shift>Tab"];
                toggle-fullscreen = ["F11"];
                close = ["<Super>q"];
                launch-web-browser = ["<Shift><Super>Return"];
              };

            "org/gnome/shell/keybindings" =
              foldl' (a: x: setAttr a (addNum "switch-to-application-" x) [])
              {}
              (range 1 10);

            "org/gnome/shell" = {
              enabled-extensions = [
                "drive-menu@gnome-shell-extensions.gcampax.github.com"
                "caffeine@patapon.info"
                "blur-my-shell@aunetx"
                "pano@elhan.io"
                "rounded-window-corners@yilozt"
                "just-perfection-desktop@just-perfection"
                "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
              ];
              # enabled-extensions =
              #   map (extension: extension.extensionUuid) extensions;
              disabled-extensions = [];

              favorite-apps = [
                "firefox.desktop"
                "wezterm.desktop"
                "org.gnome.Console.desktop"
                "org.keepassxc.KeePassXC.desktop"
                "org.gnome.Nautilus.desktop"
                "org.gnome.Software.desktop"
                "org.gnome.Calculator.desktop"
                "org.gnome.Settings.desktop"
                "thunderbird.desktop"
                "com.spotify.Client.desktop"
                "org.onlyoffice.desktopeditors.desktop"
              ];
              disable-user-extensions = false;
            };
            "org/gnome/shell/custom-accent-colors/theme-shell" = {
              accent-color = "red";
              theme-flatpak = true;
              theme-gtk3 = true;
              theme-shell = true;
            };
            "org/gnome/shell/extensions/blur-my-shell" = {
              brightness = 0.9;
              hacks-level = 0;
              noise-amount = 0.3;
              noise-lightness = 1.04;
              sigma = 40;
            };
            "org/gnome/shell/extensions/blur-my-shell/overview" = {
              blur = true;
              style-components = 2;
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
              blur = true;
              override-background = true;
              override-background-dynamically = false;
              style-panel = 0;
              unblur-in-overview = false;
            };

            "org/gnome/shell/extensions/just-perfection" = {
              accessibility-menu = false;
              alt-tab-icon-size = 0;
              animation = 1;
              app-menu = true;
              app-menu-icon = true;
              app-menu-label = true;
              background-menu = true;
              controls-manager-spacing-size = 0;
              dash = true;
              dash-icon-size = 0;
              double-super-to-appgrid = true;
              gesture = true;
              hot-corner = false;
              keyboard-layout = true;
              osd = true;
              panel = true;
              panel-arrow = true;
              panel-corner-size = 0;
              panel-in-overview = true;
              ripple-box = true;
              search = true;
              show-apps-button = true;
              startup-status = 1;
              theme = false;
              window-demands-attention-focus = true;
              window-picker-icon = true;
              window-preview-caption = true;
              window-preview-close-button = true;
              workspace = true;
              workspace-background-corner-size = 0;
              workspace-popup = true;
              workspace-switcher-should-show = false;
              workspace-wrap-around = true;
              workspaces-in-app-grid = true;
              world-clock = false;
            };

            "org/gnome/desktop/peripherals/keyboard" = {
              delay = lib.hm.gvariant.mkUint32 175;
              repeat-interval = lib.hm.gvariant.mkUint32 18;
              repeat = true;
            };
          };

        # home.file.".config/geary/user-style.css".text = ''
        #   @media (prefers-color-scheme: dark) { :root, *:not(a) { color: #eeeeec !important; background-color: #353535 !important; } }
        # '';
      })
    ];
  };
}
