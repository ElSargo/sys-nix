{pkgs, ...}: {
  fonts.packages = [(pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];})];
  fonts.enableDefaultPackages = true;
}
