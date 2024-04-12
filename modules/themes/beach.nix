{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/-G3rw6Y02D0/download?ixid=M3wxMjA3fDB8MXxhbGx8MTIyfHx8fHx8Mnx8MTcxMjg4MTk4M3w&force=true";
    sha256 = "sha256-zl4VoyRk/5R5fa6B7aJRbMqa6qml9q0EzdmzvkYF1e0=";
  };

  stylix.polarity = "light";
}
