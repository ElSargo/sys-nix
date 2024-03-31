{ lib, config, ... }: {
  home-manager.sharedModules = [{
    options = {
      palette = lib.mkOption {
        default = config.palettes.gruvbox;
        type = lib.types.attrs;
      };
      browser = lib.mkOption {
        default = "firefox";
        type = lib.types.str;
      };
    };
  }];

  imports = [ ./adwaita.nix ./gruv-adwaita.nix ./gruvbox.nix ./tokionight.nix ];
}

