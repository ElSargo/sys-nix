{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/4/4f/Pexels-elijah-o%27donnell-4173624.jpg";
    sha256 = "sha256-UPQQThdUqvsghmAXzpteWm01JTE815YyCFIWS369I+8=";
  };

  stylix.polarity = "dark";
}
