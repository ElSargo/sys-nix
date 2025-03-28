{
  description = "NixOS config";

  outputs = inputs @ {
    self,
    nixpkgs,
    unstable,
    utils,
    home-manager,
    stylix,
    helix,
    wezpy,
    ...
  }:
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig = {
        allowUnfree = true;
      };

      channels.nixpkgs.config = {
        permittedInsecurePackages = [
          "dotnet-runtime-6.0.36"
          "dotnet-sdk-wrapped-6.0.428"
          "dotnet-sdk-6.0.428"
        ];
      };

      channels.nixpkgs.config = {
        packageOverrides = pkgs: {
          vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
        };
      };
      channels.nixpkgs.overlaysBuilder = channels: [
        (f: p: {
          unstable = channels.unstable;
          wezpy = wezpy.packages.${f.system}.default;
          prompt_src = inputs.prompt;
        })
      ];

      sharedOverlays = [helix.overlays.default];

      hostDefaults = {
        modules = [
          ./modules
          ./users
          home-manager.nixosModules.home-manager
          stylix.nixosModules.stylix
        ];
      };

      hosts = import ./hosts;

      outputsBuilder = channels: {
        formatter = channels.nixpkgs.alejandra;
      };
    };

  inputs = {
    helix.url = "github:ElSargo/helix";
    nixpkgs.url = "nixpkgs/release-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    unstable.url = "nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    wezpy = {
      url = "github:ElSargo/wezpy";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix/d13ffb381c83b6139b9d67feff7addf18f8408fe";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    prompt = {
      url = "github:ElSargo/prompt";
      flake = false;
    };
  };
}
