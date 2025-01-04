{pkgs, ...}: {
  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "UbuntuMono"];})];
  fonts.enableDefaultPackages = true;
}
