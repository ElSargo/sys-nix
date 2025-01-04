{
  imports = [./shell];

  home-manager.sharedModules = [
    {
      imports = [
        ./helix.nix
        ./zoxide.nix
        ./cli-utils.nix
      ];
    }
  ];
}
