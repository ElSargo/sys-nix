{ pkgs, lib, ... }: {
  options = {
    shellAliases = lib.mkOption { };
  };

  config.shellAliases = {
    xc = "${pkgs.wl-clipboard}/bin/wl-copy";
    clip = "${pkgs.wl-clipboard}/bin/wl-copy";
    q = "exit";
    ":q" = "exit";
    c = "clear";
    r = "reset";
    ns = "nix-shell";

  };
}
