{ pkgs, ... }: {
  home.packages = with pkgs; [ carapace ];
  programs.nushell.extraEnv = # nu
    ''
      mkdir ~/.cache/carapace
      carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
    '';

  programs.nushell.extraConfig = # nu
    ''
      source ~/.cache/carapace/init.nu
    '';
}
