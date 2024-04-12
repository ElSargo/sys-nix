{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/uOi3lg8fGl4/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEyODc1NDc2fA&force=true";
    sha256 = "sha256-mzHUmGCY+/Crz9+YZfTLGgVKl8nr6sAypoCHEEugL68=";
  };

  stylix.polarity = "dark"
}
