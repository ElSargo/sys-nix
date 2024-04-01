{ pkgs, config, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = config.shellAliases // { lf = " cd $( ${pkgs.lf}/bin/lf -print-last-dir )"; };

  };
}
