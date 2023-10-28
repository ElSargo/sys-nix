{
  description = "NixOS config";

  outputs = inputs@{ self, nixpkgs, unstable, utils, home-manager, supabar
    , helix, firefox-gnome-theme, ... }:
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;

      channels.nixpkgs.overlaysBuilder = channels:
        [ (f: p: { unstable = channels.unstable; }) ];

      sharedOverlays = [
        # supabar.overlays."x86_64-linux".all
        (utils.lib.genPkgOverlay helix "helix")
      ];

      hostDefaults = {
        modules = [
          ./desktop
          ./essentials
          ./home
          home-manager.nixosModules.home-manager
          {
            home-manager.users.sargo.firefox-gnome-theme = firefox-gnome-theme;
          }
          ./virt/virt-manager.nix
        ];
      };

      hosts = {
        Basato = { modules = [ ./basato ]; };
        Wojak = { modules = [ ./wojak ]; };
      };


      outputsBuilder = channels: {

        devShell = channels.nixpkgs.mkShell { 
          name = "dev shell";
          shellHook =  ''
            if [ -n "$ZELLIJ" ]; then
            echo "well" > /dev/null
            else
              ${channels.unstable.zellij}/bin/zellij
            fi
          '';
        };
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    unstable.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    supabar.url = "github:ElSargo/supabar";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
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
