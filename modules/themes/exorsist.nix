{pkgs, ...}: let
  repo = pkgs.fetchgit {
    url = "https://codeberg.org/exorcist/wallpapers";
    rev = "7f2d29df30958703bc3c3fe1e20eb2e5a0ccaf22";
    sha256 = "sha256-atjan3lbXH56HqpKQQRMKwFN2VuqqcX6VtGnQKQ7gB4=";
  };
in {
  theme = null;
  wallpaper = "${repo}/abstract.jpg";
}
