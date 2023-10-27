{ lib, ... }: {
  options = {
    palette = lib.mkOption {
      default = import ../../palettes/gruvbox.nix;
      type = lib.types.attrs;
    };
    browser = lib.mkOption {
      default = "firefox";
      type = lib.types.str;
    };
  };
}

