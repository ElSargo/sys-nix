{...}: {
  imports = [./root.nix ./sargo.nix];
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = ".bak1";
  home-manager.sharedModules = [
    ({
      config,
      lib,
      ...
    }: {
      options = {
        browser = lib.mkOption {
          default = "firefox";
          type = lib.types.str;
        };
      };
    })
  ];
}
