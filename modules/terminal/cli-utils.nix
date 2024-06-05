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
    cargo
  ];
}
