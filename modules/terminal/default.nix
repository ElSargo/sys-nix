{
  imports = [ ./shell  ];
  
  home-manager.sharedModules = [{
    imports = [
      ./bash.nix
      ./fish.nix
      ./helix.nix
      ./lf.nix
      ./starship.nix
      ./zellij.nix
      ./zoxide.nix
      ./cli-utils.nix
    ];
  }];

}
