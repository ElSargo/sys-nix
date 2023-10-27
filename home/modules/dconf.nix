{ lib, config, ... }: {
  
    
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
        launch-web-browser = ["<Shift><Super>Return"];
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
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "places-menu@gnome-shell-extensions.gcampax.github.com"
          "drive-menu@gnome-shell-extensions.gcampax.github.com"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "blur-my-shell@aunetx"
          "color-picker@tuberry"
          "pano@elhan.io"
          "dash-to-dock@micxgx.gmail.com"
          "custom-accent-colors@demiskp"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "gnome-fuzzy-app-search@gnome-shell-extensions.Czarlie.gitlab.com"
          "caffeine@patapon.info"
          "uptime-indicator@gniourfgniourf.gmail.com"
          "grand-theft-focus@zalckos.github.com"
        ];
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
        hacks-level = 0;
        sigma = 200;
        brightness = 1;
      };
      "org/gnome/shell/extensions/auto-move-windows" = {
        applications-list =
          [ "firefox.desktop:1" "org.keepassxc.KeePassXC.desktop:10" ];
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        animation-time = 0.10000000000000002;
        apply-custom-theme = false;
        background-color = "rgb(30,30,30)";
        background-opacity = 0.7;
        click-action = "focus-minimize-or-previews";
        custom-background-color = true;
        custom-theme-shrink = false;
        dash-max-icon-size = 48;
        dock-position = "LEFT";
        height-fraction = 0.74;
        hide-delay = 0.10000000000000002;
        hot-keys = false;
        hotkeys-overlay = false;
        hotkeys-show-dock = true;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        multi-monitor = false;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "HDMI-1";
        preview-size-scale = 0.32;
        scroll-action = "cycle-windows";
        shortcut-timeout = 2.0;
        transparency-mode = "FIXED";
      };
      "org/gnome/desktop/peripherals/keyboard" = {
        delay = lib.hm.gvariant.mkUint32 175;
        repeat-interval = lib.hm.gvariant.mkUint32 18;
        repeat = true;
      };
    };

  home.file.".config/geary/user-style.css".text = ''
    @media (prefers-color-scheme: dark) { :root, *:not(a) { color: #eeeeec !important; background-color: #353535 !important; } } 
  '';
}
