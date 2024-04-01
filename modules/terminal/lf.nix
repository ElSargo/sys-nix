{pkgs, ...}: {
  home.file.".config/lf/icons".text = builtins.readFile ./lficons;
  home.packages = with pkgs; [
    bat
    coreutils
    p7zip
    poppler_utils
    unrar
    lsix
    zoxide
    skim
    ripgrep
    fish
  ];
  programs.lf = {
    enable = true;
    settings = {
      dircounts = true;
      dirfirst = true;
      icons = true;
    };
    previewer.source = pkgs.writeShellScript "pv.sh" ''
      #!/bin/sh

      case "$1" in
          *.tar*) tar tf "$1";;
          *.zip) unzip -l "$1";;
          *.rar) unrar l "$1";;
          *.7z) 7z l "$1";;
          *.pdf) pdftotext "$1" -;;
          *.png) lsix "$1" ;;
          *.jpg) lsix "$1" ;;
          *) bat --paging=never --style=numbers --terminal-width $(($2-5)) -f "$1" ;;
      esac
    '';
    commands = {
      fuzy_search =
        # bash
        ''
          ''${{ res=$(sk --ansi -i -c 'rg --line-number "{}"' | cut -d : -f1)   ;   [ ! -z "$res" ] && lf -remote "send $id select \"$res\""
          }}
        '';
      z =
        # bash
        ''
          %{{
          	result="$(zoxide query --exclude $PWD $@)"
          	lf -remote "send $id cd $result"
          }}
        '';
      trash = "%trash-put $fx";
    };
    keybindings = {
      x = ''nu -c "x $f"'';
      Z = "push :z<space>";
      "<enter>" = "push $hx<space>$f<enter>";
      O = "push $fish<space>-c<space>fhx<enter>";
      S = "push :fuzy_search<enter>";
      M = "push $mkdir<space>";
      T = "push $touch<space>";
    };
  };
}
