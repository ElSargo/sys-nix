{ pkgs, ... }:
let
  lfcd = pkgs.writeShellScriptBin "lfcd" ''
    tmp=$(mktemp)
    ${pkgs.lf}/bin/lf -last-dir-path=$tmp $@
    if [ -f "$tmp" ]; then
        dir=$(cat $tmp)
        rm -f $tmp
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                echo $dir
            fi
        fi
    fi
  '';
in {
  xc = "${pkgs.wl-clipboard}/bin/wl-copy";
  clip = "${pkgs.wl-clipboard}/bin/wl-copy";
  lf = " cd $( ${lfcd}/bin/lfcd )";
  q = "exit";
  ":q" = "exit";
  c = "clear";
  r = "reset";
  ns = "nix-shell";
}
