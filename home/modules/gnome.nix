{ pkgs, lib, config, ... }:
let
  extensions = with pkgs.gnomeExtensions; [
    removable-drive-menu
    caffeine
    blur-my-shell
    pano
    rounded-window-corners
    just-perfection
  ];
in {
  home.packages = extensions;

  dconf.settings = with builtins;
    with lib;
    let
      binds = [
        {
          binding = "<Super>Return";
          command = "kitty";
          name = "open-terminal";
        }
        {
          binding = "<Super><Shift>p";
          command = "xdg-open https://search.nixos.org/";
          name = "package-search";
        }

      ];
      mkreg = imap (i: v:
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${
          toString (i - 1)
        }/");
      mkbinds = binds:
        foldl' (a: b: a // b) { } (imap (i: v: {
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${
            toString (i - 1)
          }" = v;
        }) binds);
    in (mkbinds binds) // {

      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings =
        mkreg binds;
      "org/gnome/desktop/wm/keybindings" = {
        switch-to-workspace-1 = [ "<Super>1" ];
        switch-to-workspace-2 = [ "<Super>2" ];
        switch-to-workspace-3 = [ "<Super>3" ];
        switch-to-workspace-4 = [ "<Super>4" ];
        switch-to-workspace-5 = [ "<Super>5" ];
        switch-to-workspace-6 = [ "<Super>6" ];
        switch-to-workspace-7 = [ "<Super>7" ];
        switch-to-workspace-8 = [ "<Super>8" ];
        switch-to-workspace-9 = [ "<Super>9" ];
        switch-to-workspace-10 = [ "<Super>0" ];
        move-to-workspace-1 = [ "<Shift><Super>1" ];
        move-to-workspace-2 = [ "<Shift><Super>2" ];
        move-to-workspace-3 = [ "<Shift><Super>3" ];
        move-to-workspace-4 = [ "<Shift><Super>4" ];
        move-to-workspace-5 = [ "<Shift><Super>5" ];
        move-to-workspace-6 = [ "<Shift><Super>6" ];
        move-to-workspace-7 = [ "<Shift><Super>7" ];
        move-to-workspace-8 = [ "<Shift><Super>8" ];
        move-to-workspace-9 = [ "<Shift><Super>9" ];
        move-to-workspace-10 = [ "<Shift><Super>10" ];
        switch-applications = [ "<Super>Tab" ];
        switch-applications-backward = [ "<Super><Shift>Tab" ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [ "<Alt><Shift>Tab" ];
        toggle-fullscreen = [ "F11" ];
        close = [ "<Super>q" ];
        launch-web-browser = [ "<Shift><Super>Return" ];
      };

      "org/gnome/shell/keybindings" = {
        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];
        switch-to-application-10 = [ ];
      };

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
        disabled-extensions = [ ];

        favorite-apps = [
          "${config.browser}.desktop"
          "kitty.desktop"
          "org.keepassxc.KeePassXC.desktop"
          "org.gnome.Nautilus.desktop"
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
        style-components = 3;
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
}
