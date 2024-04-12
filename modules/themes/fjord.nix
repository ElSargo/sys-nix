{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/QHTch5kP2qY/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEyODgwNzg4fA&force=true";
    sha256 = "sha256-zl4VoyRk/5R5fa6B7aJRbMqa6qml9q0EzdmzvkYF1e0=";
  };

  stylix.polarity = "dark";
}
