{ pkgs, lib, css ? builtins.readFile
  "/nix/store/npmf3ramn9c5jb3kj3xk6hy72yczk9n3-source/configuration/extensions/tab-center-reborn.css"
, ... }:
let cbb = lib.strings.stringAsChars (c: if c == ''"'' then ''\"'' else c) css;
in builtins.derivation {
  name = "ffdb";
  args = [ ./builder.bash ];
  builder = "${pkgs.bash}/bin/bash";
  system = builtins.currentSystem;
  sqlite = "${pkgs.sqlite}";
  coreutils = "${pkgs.coreutils}";
  data = # json

    ''
      [
          {
              "data": "{\"customCSS\":\"${cbb}\"}",
              "ext_id": "tabcenter-reborn@ariasuni",
              "sync_change_counter": 1
          }
      ]
    '';
}
