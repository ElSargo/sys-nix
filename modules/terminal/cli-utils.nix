{pkgs, ...}: {
  home.packages = with pkgs; [
    ripgrep
    wl-clipboard
    unzip
    eza
    wget
    trash-cli
    delta
    htop
    typos
    pastel
    yazi
  ];
  programs = {
    zoxide.enable = true;
    lazygit = {
      enable = true;
      settings = {
        git = {
          autofetch = true;
          paging = {
            colorarg = "always";
            colorArg = "always";
            pager = "delta --dark --paging=never --24-bit-color=never";
          };
        };
      };
    };

    direnv = {
      nix-direnv.enable = true;
      enable = true;
    };
    git = {
      enable = true;
      userName = "Oliver Sargison";
      userEmail = "sargo@sargo.cc";
      delta.enable = true;
    };
    bash = {enable = true;};
  };
}
