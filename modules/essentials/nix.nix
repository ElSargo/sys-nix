{pkgs, ...}: {
  programs.nix-index.enable = true;
  programs.command-not-found.enable = false;
  services.envfs.enable = true;

  nix = {
    generateRegistryFromInputs = true;
    generateNixPathFromInputs = true;
    linkInputs = true;
    settings = {
      warn-dirty = false;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "sargo"];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  environment.systemPackages = with pkgs; [
    pkgs.nixVersions.nix_2_18
    fup-repl
  ];
}
