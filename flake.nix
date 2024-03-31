{
  description = "NixOS config";

  outputs = inputs@{ self, nixpkgs, unstable, utils, home-manager
    , firefox-gnome-theme, ... }:
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
      channels.nixpkgs.overlaysBuilder = channels:
        [ (f: p: { unstable = channels.unstable; }) ];

      hostDefaults = {
        modules = [
          ./modules
          ./users
          home-manager.nixosModules.home-manager
          {
            home-manager.sharedModules =
              [{ config.firefox-gnome-theme = firefox-gnome-theme; }];
          }
        ];
      };

      hosts = import ./hosts;
    };

  inputs = {
    nixpkgs.url = "nixpkgs/release-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };
}
