{
  home-manager.sharedModules = [
    ({
      config,
      lib,
      ...
    }: {
      options = {
        browser = lib.mkOption {
          default = "firefox";
          type = lib.types.str;
        };
      };
    })
    ({
      config,
      pkgs,
      ...
    }: {
      home.packages = with pkgs; [junction];
      xdg = {
        enable = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            # "text/plain" = "Helix.desktop";
            # "application/zip" = "thunar.desktop";
            # "application/rar" = "thunar.desktop";
            # "application/7z" = "thunar.desktop";
            # "application/*tar" = "thunar.desktop";
            # "inode/directory" = "thunar.desktop";
            # "application/pdf" = "draw.desktop";
            # "image/*" = "${config.browser}.desktop";
            # "video/*" = "${config.browser}.desktop";
            # "audio/*" = "${config.browser}.desktop";
            # "text/html" = "${config.browser}.desktop";
            # "x-scheme-handler/http" = "${config.browser}.desktop";
            # "x-scheme-handler/https" = "${config.browser}.desktop";
            # "x-scheme-handler/ftp" = "${config.browser}.desktop";
            # "x-scheme-handler/chrome" = "${config.browser}.desktop";
            # "x-scheme-handler/about" = "${config.browser}.desktop";
            # "x-scheme-handler/unknown" = "${config.browser}.desktop";
            # "application/x-extension-htm" = "${config.browser}.desktop";
            # "application/x-extension-html" = "${config.browser}.desktop";
            # "application/x-extension-shtml" = "${config.browser}.desktop";
            # "application/xhtml+xml" = "${config.browser}.desktop";
            # "application/x-extension-xhtml" = "${config.browser}.desktop";
            # "application/x-extension-xht" = "${config.browser}.desktop";
            "text/plain" = "junctoin.desktop";
            "application/zip" = "junctoin.desktop";
            "application/rar" = "junctoin.desktop";
            "application/7z" = "junctoin.desktop";
            "application/*tar" = "junctoin.desktop";
            "inode/directory" = "junctoin.desktop";
            "application/pdf" = "junctoin.desktop";
            "image/*" = "junctoin.desktop";
            "video/*" = "junctoin.desktop";
            "audio/*" = "junctoin.desktop";
            "text/html" = "junctoin.desktop";
            "x-scheme-handler/http" = "junctoin.desktop";
            "x-scheme-handler/https" = "junctoin.desktop";
            "x-scheme-handler/ftp" = "junctoin.desktop";
            "x-scheme-handler/chrome" = "junctoin.desktop";
            "x-scheme-handler/about" = "junctoin.desktop";
            "x-scheme-handler/unknown" = "junctoin.desktop";
            "application/x-extension-htm" = "junctoin.desktop";
            "application/x-extension-html" = "junctoin.desktop";
            "application/x-extension-shtml" = "junctoin.desktop";
            "application/xhtml+xml" = "junctoin.desktop";
            "application/x-extension-xhtml" = "junctoin.desktop";
            "application/x-extension-xht" = "junctoin.desktop";
          };
        };
      };
    })
  ];
}
