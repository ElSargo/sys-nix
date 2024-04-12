{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/TWoL-QCZubY/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEyODc4MjE0fA&force=true";
    sha256 = "sha256-BagILiZrCR3DIhJEBmhK/HwbE+OHmkQcTDugxw66ZTU=";
  };

  stylix.polarity = "dark";
}
