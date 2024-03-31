{ pkgs, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = (import ./shell_aliases.nix { inherit pkgs; });
  };
}
