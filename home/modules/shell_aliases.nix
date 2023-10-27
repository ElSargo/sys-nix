{ pkgs, ... }: {
  xc = "wl-copy";
  clip = "wl-copy";
  lf = "lfcd";
  q = "exit";
  ":q" = "exit";
  c = "clear";
  r = "reset";
  xplr = "cd $(${pkgs.xplr}/bin/xplr)";
  ns = "nix-shell";
  za = "${pkgs.zellij}/bin/zellij a";
  zl =
    " ${pkgs.zellij}/bin/zellij a $(pwd | ${pkgs.sd} '/' '\\n' | tail -n 1) || zellij --layout ./layout.kdl -s $(pwd | sd '/' '\\n' | tail -n 1)";

}
