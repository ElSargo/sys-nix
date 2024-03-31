{ config, ... }: {
  programs.bash = {
    enable = true;
    shellAliases = config.shellAliases;
  };
}
