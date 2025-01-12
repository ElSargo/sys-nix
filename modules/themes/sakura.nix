{pkgs, ...}: let
  test = 2;
  source = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/4/4f/Pexels-elijah-o%27donnell-4173624.jpg";
    sha256 = "sha256-UPQQThdUqvsghmAXzpteWm01JTE815YyCFIWS369I+8=";
  };

  image = pkgs.runCommand "image.png" {} ''
    ${pkgs.imagemagick}/bin/magick convert ${source} -channel R  -fx '2.0*u+(1-u)^0.8-1' -channel G  -fx '2.0*u+(1-u)^1.05-1' $out;
  '';
in {
  theme = null;
  wallpaper = image;

  stylix.polarity = "dark";
}
