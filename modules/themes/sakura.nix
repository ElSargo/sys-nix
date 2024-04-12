{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/uOi3lg8fGl4/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEyODc1NDc2fA&force=true";
    sha256 = "sha256-u7Z0FIIb0I1JQ0txhEfFUWb5fz1VA6GO7gNiPDhsXJI=";
  };

  stylix.polarity = "dark";
}
