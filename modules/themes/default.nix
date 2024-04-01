{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./gruvbox.nix];

  options = {
    wallpaper = lib.mkOption {
      default = pkgs.runCommand "image.png" {} ''
        COLOR=$(${pkgs.yq}/bin/yq -r .base00 ${config.theme})
        COLOR="#"$COLOR
        ${pkgs.imagemagick}/bin/magick convert -size 1920x1080 xc:$COLOR $out;
      '';
    };

    theme = lib.mkOption {
      default = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    };

    mkTheme = lib.mkOption {
      default = theme: "${pkgs.base16-schemes}/share/themes/${theme}.yaml";
    };
  };

  config = {
    stylix.base16Scheme = config.theme;
    stylix.image = config.wallpaper;
    stylix.opacity = {
      applications = 0.85;
      terminal = 0.85;
      popups = 0.85;
      desktop = 0.85;
    };
    home-manager.sharedModules = [
      {
        stylix.polarity = "dark";
        # stylix.targets.firefox.enable = false;
        stylix.targets.firefox.profileNames = ["sargo"];
        stylix.opacity = {
          applications = 0.85;
          terminal = 0.85;
          popups = 0.85;
          desktop = 0.85;
        };
      }
    ];
  };
}
