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
    nixos-cachyos-kernel,
    ...
  }: let
    pkgs = self.pkgs.x86_64-linux.nixpkgs;
  in
    utils.lib.mkFlake {
      inherit self inputs;
      channelsConfig = {
        allowUnfree = true;
      };

      channels.nixpkgs.overlaysBuilder = channels: [
        (f: p: {
          unstable = channels.unstable;
          wezpy = wezpy.packages.${f.system}.default;
          quickshell = inputs.quickshell.packages.${f.system}.default;
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
          nixos-cachyos-kernel.nixosModules.default
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
    nixos-cachyos-kernel.url = "github:drakon64/nixos-cachyos-kernel";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
