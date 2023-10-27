{ pkgs, ... }: {
  fonts.fonts =
    [ (pkgs.unstable.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  fonts.enableDefaultFonts = true;
}
