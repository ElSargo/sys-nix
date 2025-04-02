{pkgs, ...}: {
  users.defaultUserShell = pkgs.unstable.nushell;
  home-manager.sharedModules = [
    ({config, ...}: {
      imports = [
        ./helix
        ./nushell.nix
        ./prompt.nix
      ];

      home.packages = with pkgs; [
        ripgrep
        unzip
        wget
        trash-cli
        htop
        pastel
        cliphist
        wl-clipboard
        yazi
      ];

      programs = {
        carapace.enable = true;
        zoxide.enable = true;
        lazygit = {
          enable = true;
          settings = {
            git = {
              autofetch = true;
              paging = {
                colorarg = "always";
                colorArg = "always";
                pager = "${pkgs.delta}/bin/delta --dark --paging=never --24-bit-color=never";
              };
            };
          };
        };

        direnv = {
          nix-direnv.enable = true;
          enable = true;
        };
        git = {
          enable = true;
          userName = "Oliver Sargison";
          userEmail = "sargo@sargo.cc";
          delta.enable = true;
        };
      };
    })
  ];
}
