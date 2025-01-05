{
  config,
  pkgs,
  ...
}: {
  config = {
    theme = config.mkTheme "tokyo-night-dark";
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
        programs.helix.settings.theme = lib.mkForce "tokyonight";
        programs.helix.themes = {
          tok = {
            inherits = "tokyonight";
            "ui.background" = {
              fg = "foreground";
              bg = "background";
            };

            "comment" = {
              fg = "comment";
              modifiers = ["italic"];
            };
            "keyword.function" = {
              fg = "magenta";
              modifiers = ["italic"];
            };
            "markup.quote" = {modifiers = ["italic"];};
          };
        };
      })
    ];
  };
}
