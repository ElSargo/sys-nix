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
    nixfmt
    typos
    pastel
    cargo
  ];
}
