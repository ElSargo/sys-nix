{
  pkgs,
  config,
  lib,
  ...
}: let
  prompt_pkg = pkgs.rustPlatform.buildRustPackage rec {
    pname = "prompt";
    version = "0.0.0";

    src = pkgs.prompt_src;
    cargoLock.lockFile = "${src}/Cargo.lock";
  };
in {
  options = {
    enableNushellIntegration =
      lib.mkEnableOption "Nushell integration"
      // {
        default = true;
      };
  };

  config.programs.nushell = lib.mkIf config.enableNushellIntegration {
    extraConfig =
      #nu
      ''
        load-env {
          PROMPT_COMMAND: {|| ${prompt_pkg}/bin/prompt }
          PROMPT_INDICATOR: ""
          PROMPT_COMMAND_RIGHT: {||}
        }
      '';
  };
}
