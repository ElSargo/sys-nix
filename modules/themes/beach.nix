{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/QHTch5kP2qY/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEyODgwNzg4fA&force=true";
    sha256 = "sha256-IU4IAnlAXbft8kLJ9WOlxEsOl97PDyKM1SPTsQXHwEA=";
  };

  stylix.polarity = "light";
}
