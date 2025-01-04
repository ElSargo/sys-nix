{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    helix-package = lib.mkOption {
      default = pkgs.unstable.helix;
      type = lib.types.package;
    };
  };

  config = {
    home.packages = with pkgs.unstable; [nil marksman taplo];
    programs.helix = {
      enable = true;
      package = config.helix-package;
      settings = {
        editor = {
          soft-wrap = {enable = false;};
          statusline = {
            left = ["mode" "spinner" "file-name" "file-modification-indicator"];
            center = ["workspace-diagnostics" "version-control"];
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
            esc = ["collapse_selection" "keep_primary_selection"];
          };
        };
      };
      languages = {};
    };
  };
}
