{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [./tokyonight.nix];

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
    stylix.enable = true;
    stylix.base16Scheme = lib.mkIf (config.theme != null) config.theme;
    stylix.image = config.wallpaper;
    home-manager.sharedModules = [
      {
        stylix.enable = true;
        stylix.polarity = "dark";
        stylix.targets.firefox.enable = false;
        stylix.targets.firefox.profileNames = ["sargo"];
      }
    ];
  };
}
