{
  imports = [./shell];

  home-manager.sharedModules = [
    {
      imports = [
        ./helix.nix
        ./lf.nix
        # ./starship.nix
        ./zellij.nix
        ./zoxide.nix
        ./cli-utils.nix
      ];
    }
  ];
}
