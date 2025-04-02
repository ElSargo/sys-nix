{...}: {
  imports = [./root.nix ./sargo.nix];
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = ".bak1";
}
