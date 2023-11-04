{ pkgs, ... }: {
  programs.nushell = let
    nuscripts = pkgs.fetchFromGitHub {
      owner = "nushell";
      repo = "nu_scripts";
      rev = "8add04deb892a4de743646f7d8e9ce9c0333d776";
      sha256 = "sha256-9leFXzPKSiW0m0m/XswOeUFX6eWvV2YwBQL8hLxqu4Q=";

    };
  in {
    package = pkgs.nushell;
    enable = false;

    configFile = {
      text = # nu
        ''
              $env.config = {
              table: {
                mode: rounded
              }
              show_banner: false,
              ls: {
                use_ls_colors: true
                clickable_links: true
              }
              cd: {
                abbreviations: true  
               }
              rm: {
                always_trash: true
              }
              hooks: {
                  command_not_found: {
                      |cmd| ( 
                         let foundCommands = (nix-locate --minimal --no-group --type x --type s --top-level --whole-name --at-root ("/bin/" + $cmd) | lines | str replace ".out" "");
                         if ($foundCommands | length) == 0  {
                           print "Command not found"
                        } else if $cmd != "wl-copy" {
                            print "Command is avalible in the following packages"
                            print $foundCommands 
                            print ("nix-shell -p " + $foundCommands.0 + " coppied to clipboard") 
                            echo ("nix-shell -p " + ($foundCommands | get 0) )| wl-copy;
                        }
                      )
                  }
              }
            }


            export def rbs [] {
              sudo nixos-rebuild switch --flake ~/sys-nix#($env.hostname) -p $env.hostname;
            }

            export def x [name:string] {
              let exten = [ [ex com];
                                ['.tar.bz2' '${pkgs.gnutar}/bin/tar xjf']
                                ['.tar.gz' '${pkgs.gnutar}/bin/tar xzf']
                                ['.bz2' '${pkgs.bzip2}/bin/bunzip2']
                                ['.rar' '${pkgs.unrar}/bin/unrar x']
                                ['.tbz2' '${pkgs.gnutar}/bin/tar xjf']
                                ['.tgz' '${pkgs.gnutar}/bin/tar xzf']
                                ['.zip' '${pkgs.unzip}/bin/unzip']
                                ['.7z' '${pkgs.p7zip}/bin/7z x']
                                ['.tar.xz' '${pkgs.gnutar}/bin/tar xvf']
                                ['.tar.zst' '${pkgs.gnutar}/bin/tar xvf']
                                ['.tar' '${pkgs.gnutar}/bin/tar xvf']
                                ['.gz' '${pkgs.gzip}/bin/gunzip']
                                ['.Z' '(${pkgs.gzip}/bin/uncompress']
                                ]
              let command = ($exten|where $name =~ $it.ex|first)
              if ($command|is-empty) {
                echo 'Error! Unsupported file extension'
              } else {
                nu -c ($command.com + ' ' + $name)
              }
            }

          # export use "${nuscripts}/modules/background_task/job.nu"
          export use "${nuscripts}/modules/network/ssh.nu"
          use "${nuscripts}/custom-completions/zellij/zellij-completions.nu" *
          use "${nuscripts}/custom-completions/git/git-completions.nu" *
          use "${nuscripts}/custom-completions/cargo/cargo-completions.nu" *
          use "${nuscripts}/custom-completions/make/make-completions.nu" *
          use "${nuscripts}/custom-completions/nix/nix-completions.nu" *

          export def "cargo search" [ query: string, --limit=10] { 
              ^cargo search $query --limit $limit
              | lines 
              | each { 
                  |line| if ($line | str contains "#") { 
                      $line | parse --regex '(?P<name>.+) = "(?P<version>.+)" +# (?P<description>.+)' 
                  } else { 
                      $line | parse --regex '(?P<name>.+) = "(?P<version>.+)"' 
                  } 
              } 
              | flatten
              | each { |r| {name: $r.name, version: $r.version ,description: $r.description, link: ("https://lib.rs/" + $r.name ) } }

          }

        '';
    };

    envFile = {
      text = # nu
        ''
          $env.DIRENV_LOG_FORMAT = ""
          $env.EDITOR = "hx"
          $env.VISUAL = "hx"
        '';
    };

    shellAliases = (import ./shell_aliases.nix { inherit pkgs; }) // {
      unix = "curl -L http://git.io/unix";
      nix-develop = "nix develop -c nu";
      nix-shell = "nix-shell --command nu";
      ns = "nix-shell --command nu -p";
      nd = "nix develop --command nu";
      xc = "wl-copy";
      clip = "wl-copy";
      lf = "cd (fish -c ' lfcd ; pwd ')";
      i = "nix-env -iA nixos.";
      q = "exit";
      ":q" = "exit";
      c = "clear";
      r = "reset";
      za = "zellij a";
    };
  };
}
