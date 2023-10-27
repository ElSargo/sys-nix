{ pkgs, lib, config, ... }: {
  options = {
    helix-package = lib.mkOption {
      default = pkgs.unstable.helix;
      type = lib.types.package;
    };
  };

  config = {
    home.packages = with pkgs.unstable; [ nil marksman taplo ];
    programs.helix = {
      enable = true;
      package = config.helix-package;

      themes = {
        gruvy = {
          inherits = "gruvbox";
          "ui.background" = {
            fg = "foreground";
            bg = "background";
          };
          rainbow = [
            {
              fg = config.palette.br_orange;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_red;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_green;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_yellow;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_blue;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_aqua;
              modifiers = [ "bold" ];
            }
            {
              fg = config.palette.br_purple;
              modifiers = [ "bold" ];
            }
          ];
          # "comment" = {  modifiers = ["italic"]; };
          "keyword" = {
            fg = config.palette.br_red;
            modifiers = [ "italic" ];
          };
          # "keyword" = {  modifiers = ["italic"]; };
          # "keyword.function" = {  modifiers = ["italic"]; };
          # "variable.parameter" = {  modifiers = ["italic"]; };
          # "markup.italic" = {  modifiers = ["italic"]; };
          # "markup.quote" = {  modifiers = ["italic"]; };
        };
        tokio = {
          inherits = "tokyonight";
          "ui.background" = {
            fg = "foreground";
            bg = "background";
          };
        };
      };
      settings = {
        theme = config.palette.helix_theme;
        # rainbow-brackets = false;
        editor = {
          soft-wrap = { enable = false; };
          statusline = {
            left = [ "mode" "spinner" "file-name" "file-modification-indicator" ];
            center = [ "workspace-diagnostics" "version-control" ];
            right = [
              "diagnostics"
              "selections"
              "position"
              "total-line-numbers"
              "position-percentage"
              "file-encoding"
            ];
          };
          line-number = "relative";
          scrolloff = 10;
          cursorline = true;
          auto-save = true;
          color-modes = true;
          bufferline = "multiple";
          cursor-shape = {
            insert = "bar";
            normal = "block";
          };
          lsp.display-messages = true;
          lsp.display-inlay-hints = true;
          indent-guides = {
            render = true;
            character = "│";
          };
        };
        keys = {
          normal = let
            quote-file = pkgs.writeText "quote" ''"'';
            mkJump = file: [
              "collapse_selection"
              ":open ${file}"
              "search_selection"
              ":bc"
              "search_next"
              "select_mode"
              "match_brackets"
              "extend_char_left"
              "flip_selections"
              "extend_char_right"
              "normal_mode"

            ];
          in {
            X = [
              "goto_first_nonwhitespace"
              "select_mode"
              "goto_line_end"
              "normal_mode"
            ];
            A-l = mkJump (pkgs.writeText "left-bracket" "{");
            A-h = mkJump (pkgs.writeText "right-bracket" "}");
            A-j = mkJump (pkgs.writeText "left-paren" "(");
            A-k = mkJump (pkgs.writeText "right-paren" ")");
            C-l = mkJump (pkgs.writeText "left-brace" "[");
            C-h = mkJump (pkgs.writeText "right-brace" "]");
            C-j = mkJump quote-file;
            C-k = mkJump quote-file;
            esc = [ "collapse_selection" "keep_primary_selection" ];
            space = { n = [ ":write-all" ":sh nixfmt *.nix" ":reload-all" ]; };
          };
        };
      };
      languages = { };
    };  
  };
}
