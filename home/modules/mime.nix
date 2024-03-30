{ pkgs, config, ... }: {
  # home.packages = with pkgs; [ libreoffice ];
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = "Helix.desktop";
        "application/zip" = "thunar.desktop";
        "application/rar" = "thunar.desktop";
        "application/7z" = "thunar.desktop";
        "application/*tar" = "thunar.desktop";
        "inode/directory" = "thunar.desktop";
        "application/pdf" = "draw.desktop";
        "image/*" = "${config.browser}.desktop";
        "video/*" = "${config.browser}.desktop";
        "audio/*" = "${config.browser}.desktop";
        "text/html" = "${config.browser}.desktop";
        "x-scheme-handler/http" = "${config.browser}.desktop";
        "x-scheme-handler/https" = "${config.browser}.desktop";
        "x-scheme-handler/ftp" = "${config.browser}.desktop";
        "x-scheme-handler/chrome" = "${config.browser}.desktop";
        "x-scheme-handler/about" = "${config.browser}.desktop";
        "x-scheme-handler/unknown" = "${config.browser}.desktop";
        "application/x-extension-htm" = "${config.browser}.desktop";
        "application/x-extension-html" = "${config.browser}.desktop";
        "application/x-extension-shtml" = "${config.browser}.desktop";
        "application/xhtml+xml" = "${config.browser}.desktop";
        "application/x-extension-xhtml" = "${config.browser}.desktop";
        "application/x-extension-xht" = "${config.browser}.desktop";
      };
    };
  };
}
