{pkgs ,...}: {
  home.packages = with pkgs;[
    ripgrep 
    wl-clipboard 
    unzip
    exa
    wget
    trash-cli
    delta
    htop
    nixfmt
    typos
    pastel
    cargo
  ];
}
