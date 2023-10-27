{ pkgs, ... }:
let lfcd = pkgs.writeShellScriptBin "lfcd " ''${pkgs.lf} -print-last-dir "$@"'';
in {
  xc = "${pkgs.wl-clipboard}/bin/wl-copy";
  clip = "${pkgs.wl-clipboard}/bin/wl-copy";
  lf = " cd $(${lfcd})";
  q = "exit";
  ":q" = "exit";
  c = "clear";
  r = "reset";
  ns = "nix-shell";
}
