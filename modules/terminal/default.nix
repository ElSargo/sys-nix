{
  imports = [./shell];

  home-manager.sharedModules = [
    {
      imports = [
        ./helix
        ./zoxide.nix
        ./cli-utils.nix
      ];
    }
  ];
}
