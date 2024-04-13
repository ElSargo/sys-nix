{pkgs, ...}: let
  image = pkgs.fetchurl {
    url = "https://unsplash.com/photos/cqKC4F3k7P8/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzEzMDQ0MDgxfA&force=true";
    sha256 = "sha256-z4M9qfCQZFj3bTb8CpO7lB1v38Ga5rdl2W78SMpNFXw=";
  };
in {
  theme = null;
  wallpaper = image;

  stylix.polarity = "dark";
}
