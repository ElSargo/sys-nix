{
  pkgs,
  config,
  lib,
  ...
}: let
  prompt_pkg = pkgs.rustPlatform.buildRustPackage rec {
    pname = "prompt";
    version = "0.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "ElSargo";
      repo = "prompt";
      rev = "4eb5634efa86f64ba05056dc7e6cfec5f6d1dfc1";
      hash = "sha256-LzV0lwuvGkytM0BESGo+KVeCIyMvUu0KCInUaYIV8Fo=";
    };
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
