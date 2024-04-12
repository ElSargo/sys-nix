{pkgs, ...}: {
  theme = null;
  wallpaper = pkgs.fetchurl {
    url = "https://github.com/iluvgirlswithglasses/dotfiles/blob/9c1c911a59925e75b6144b695f3d4249c4e11c21/.wallpapers/sakura--rchannel-boosted--1920-1080.png";
    sha256 = "sha256-u7Z0FIIb0I1JQ0txhEfFUWb5fz1VA6GO7gNiPDhsXJI=";
  };

  stylix.polarity = "dark";
}
