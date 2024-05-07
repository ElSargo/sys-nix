{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://unsplash.com/photos/ii5JY_46xH0/download?force=true";
    sha256 = "sha256-fg7K/pnqePOj4XDAb1RQremx2FQF4fs1TSBOHQFqVXs=";
  };

  # stylix.polarity = "light";
}
