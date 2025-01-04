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
      rev = "0c61c5f9a1998e2231aab981aab2e96d6ad50926";
      hash = "sha256-sB6tfhsyBHMJdr83gTlHJ/i8J4v6MmsID/1ZnJkJcbo=";
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
