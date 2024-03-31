{
  home-manager.sharedModules = [
    {
      
  imports = [
    ./bash.nix
    ./dark-theme.nix
    ./firefox
    ./fish.nix
    ./helix.nix
    ./kitty.nix
    ./lf.nix
    ./mime.nix
    ./starship.nix
    ./zellij.nix
    ./zoxide.nix
    ./desktop-programs.nix
    ./cli-utils.nix
    ./nu.nix
  ];
    }    
  ];
}
