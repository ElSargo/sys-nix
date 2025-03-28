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
      systemPackages = with pkgs; [valent libnotify morewaita-icon-theme];
      gnome.excludePackages = with pkgs;
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
          # caffeine
          # run-or-raise
          # just-perfection
          # color-picker
          # looking-glass-button
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
            (a: x: (wkb (wkb a "switch-to-workspace-" "<Shift><Alt>" x)
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

            "org/gnome/shell" = {
              enabled-extensions = [
                # "drive-menu@gnome-shell-extensions.gcampax.github.com"
                # "caffeine@patapon.info"
                # "just-perfection-desktop@just-perfection"
                # "color-picker@tuberry"
                # "run-or-raise@edvard.cz"
                # "lgbutton@glerro.gnome.gitlab.io"
              ];

              favorite-apps = [
                "app.zen_browser.zen.desktop"
                "org.wezfurlong.wezterm.desktop"
                "obsidian.desktop"
                "org.gnome.Nautilus.desktop"
                "com.github.neithern.g4music.desktop"
                "custom-desktop-starter.044528.desktop"
                "org.speedcrunch.SpeedCrunch.desktop"
                "ca.andyholmes.Valent.desktop"
                "org.gnome.Software.desktop"
                "org.gnome.Settings.desktop"
              ];
              disable-user-extensions = false;
            };

            "org/gnome/shell/extensions/run-or-raise" = {
              dbus = true;
              minimize-when-unfocused = true;
            };

            # "org/gnome/shell/extensions/just-perfection" = {
            #   accessibility-menu = false;
            #   alt-tab-icon-size = 0;
            #   animation = 1;
            #   app-menu = true;
            #   app-menu-icon = true;
            #   app-menu-label = true;
            #   background-menu = true;
            #   controls-manager-spacing-size = 0;
            #   dash = true;
            #   dash-icon-size = 0;
            #   double-super-to-appgrid = true;
            #   gesture = true;
            #   hot-corner = false;
            #   keyboard-layout = true;
            #   osd = true;
            #   panel = true;
            #   panel-arrow = true;
            #   panel-corner-size = 0;
            #   panel-in-overview = true;
            #   ripple-box = true;
            #   search = true;
            #   show-apps-button = true;
            #   startup-status = 1;
            #   theme = false;
            #   window-demands-attention-focus = true;
            #   window-picker-icon = true;
            #   window-preview-caption = true;
            #   window-preview-close-button = true;
            #   workspace = true;
            #   workspace-background-corner-size = 0;
            #   workspace-popup = true;
            #   workspace-switcher-should-show = false;
            #   workspace-wrap-around = true;
            #   workspaces-in-app-grid = true;
            #   world-clock = false;
            # };

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
