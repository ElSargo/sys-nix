{
  description = "NixOS config";

  outputs = inputs@{ self, nixpkgs, unstable, utils, home-manager, supabar
    , helix, firefox-gnome-theme, nur, ... }:
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels:
        [ (f: p: { unstable = channels.unstable; }) ];

      sharedOverlays = [
        # supabar.overlays."x86_64-linux".all
        (utils.lib.genPkgOverlay helix "helix")
        nur.overlay
      ];

      hostDefaults = {
        modules = [
          ./desktop
          ./essentials
          ./home
          home-manager.nixosModules.home-manager
          nur.nixosModules.nur
          {
            home-manager.users.sargo.firefox-gnome-theme = firefox-gnome-theme;
          }
          # ./virt/virt-manager.nix
        ];
      };

      hosts = {
        Basato = { modules = [ ./basato nur.nixosModules.nur ]; };
        Wojak = { modules = [ ./wojak ]; };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    unstable.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    supabar.url = "github:ElSargo/supabar";
    nur.url = "github:nix-community/NUR";
    helix = {
      url = "github:the-mikedavis/helix";
      inputs.nixpkgs.follows = "unstable";
    };
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };
  };
}
