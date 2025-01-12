{
  lib,
  pkgs,
  ...
}: {
  config = let
    theme = pkgs.writeTextFile {
      name = "ashen.yaml";
      executable = true;
      text =
        #yaml
        ''
          system: "base16"
          name: "Ashen"
          author: "Daniel Fichtinger https://github.com/ficcdaf"
          variant: "Dark"
          palette:
            base00: "#121212"
            base01: "#B14242"
            base02: "#D87C4A"
            base03: "#B14242"
            base04: "#949494"
            base05: "#949494"
            base06: "#a7a7a7"
            base07: "#b4b4b4"
            base08: "#d5d5d5"
            base09: "#B14242"
            base0A: "#D87C4A"
            base0B: "#B14242"
            base0C: "#949494"
            base0D: "#a7a7a7"
            base0E: "#b4b4b4"
            base0F: "#d5d5d5"
        '';
    };
  in {
    theme = "${theme}";
    stylix = {
      autoEnable = true;
      targets.grub = {
        enable = true;
        useImage = true;
      };
    };

    boot.plymouth.enable = true;

    wallpaper = pkgs.fetchurl {
      # url = "https://unsplash.com/photos/P-yzuyWFEIk/download?ixid=M3wxMjA3fDB8MXxzZWFyY2h8MTV8fHNjZW5lcnl8ZW58MHx8fHwxNzExOTQ4MDk4fDA&force=true";
      # hash = "sha256-OX4Cykle4Rd7gYRRxE92CXAXpdAhpPUeXLNmMzP2+tI=";
      url = "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/b3be1dae-3caa-4d45-be6c-3de586ba95e2/deksqsf-2e1dd0d4-022a-4441-a03d-e910a7f667a7.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7InBhdGgiOiJcL2ZcL2IzYmUxZGFlLTNjYWEtNGQ0NS1iZTZjLTNkZTU4NmJhOTVlMlwvZGVrc3FzZi0yZTFkZDBkNC0wMjJhLTQ0NDEtYTAzZC1lOTEwYTdmNjY3YTcuanBnIn1dXSwiYXVkIjpbInVybjpzZXJ2aWNlOmZpbGUuZG93bmxvYWQiXX0.juT49_tCFetNxpWIyWFm_TdQvj8Poxp7Vd7cwL4XpJM";
      sha256 = "sha256-oEVVgNl9XeF+ybgDmKw6/Q3HrBbrQ7emLfSimYLtHqM=";
    };

    home-manager.sharedModules = [
      ({
        pkgs,
        lib,
        ...
      }: {
        programs.helix.settings.theme = lib.mkForce "hex_toxic";
      })
    ];
  };
}
