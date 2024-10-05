{
  description = "NixOS config";

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    utils,
    home-manager,
    stylix,
    firefox-gnome-theme,
    helix,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.config.packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
      };
      channels.nixpkgs.overlaysBuilder = channels: [(f: p: {unstable = channels.unstable;})];

      sharedOverlays = [helix.overlays.default];

      hostDefaults = {
        modules = [
          ./modules
          ./users
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
          {
            home-manager.sharedModules = [
              ({...}: {
                home.file.".mozilla/firefox/sargo/chrome/firefox-gnome-theme/".source = "${firefox-gnome-theme}";
                programs.firefox.profiles.sargo = {
                  userChrome = ''
                    @import "firefox-gnome-theme/userChrome.css";
                  '';

                  userContent = ''
                    @import "firefox-gnome-theme/userContent.css";
                  '';
                };
              })
            ];
          }
        ];
      };

      hosts = import ./hosts;

      outputsBuilder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };

  inputs = {
    helix.url = "github:ElSargo/helix";
    nixpkgs.url = "nixpkgs/release-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    unstable.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };
}
