inputs@{ home-manager, nixpkgs, unstable, utils, ... }:
utils.lib.eachDefaultSystem (system: {
  homeConfigurations = {
    sargo = home-manager.lib.homeManagerConfiguration {
      # Note: I am sure this could be done better with flake-utils or something
      pkgs = import nixpkgs { system = "x86_64-darwin"; };

      modules = [ ./home ]; # Defined later
    };
  };
})
