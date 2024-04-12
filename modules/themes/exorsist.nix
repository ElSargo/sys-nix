{pkgs, ...}: let
  repo = pkgs.fetchGit {
    url = "https://codeberg.org/exorcist/wallpapers";
    rev = "7f2d29df30958703bc3c3fe1e20eb2e5a0ccaf22";
  };
in {
  theme = null;
  wallpaper = "${repo}/abstract.jpg";
}
