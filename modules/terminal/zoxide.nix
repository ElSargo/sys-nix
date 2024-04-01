{pkgs, ...}: {
  programs.zoxide = {
    package = pkgs.zoxide;
    enable = true;
    # enableNushellIntegration = false;
  };
}
