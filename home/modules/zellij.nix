{ pkgs, config, ... }:
# let supabar-wasm = ''"file:${pkgs.supabar}/bin/zellij-supabar.wasm"'';
# in 
{
  programs.zellij = {
    enable = true;
    package = pkgs.unstable.zellij;
    enableZshIntegration = false;
    settings = {
      default_layout = "compact";
      pane_frames = true;
      ui = { pane_frames = { rounded_corners = true; }; };
      keybinds = {
        unbind = "Ctrl o";
        normal = {
          "bind \"Ctrl d\"" = { "" = "Detach"; };
          "bind \"Alt 1\"" = { GoToTab = 1; };
          "bind \"Alt 2\"" = { GoToTab = 2; };
          "bind \"Alt 3\"" = { GoToTab = 3; };
          "bind \"Alt 4\"" = { GoToTab = 4; };
          "bind \"Alt 5\"" = { GoToTab = 5; };
          "bind \"Alt 6\"" = { GoToTab = 6; };
          "bind \"Alt 7\"" = { GoToTab = 7; };
          "bind \"Alt 8\"" = { GoToTab = 8; };
          "bind \"Alt 9\"" = { GoToTab = 9; };
          "bind \"Alt 0\"" = { GoToTab = 10; };
          "bind \"Alt s\"" = {
            "LaunchOrFocusPlugin \"zellij:session-manager\"" = {
              floating = true;
            };
          };
        };
      };
      theme = "gruvbox_dark";
      themes = {
        gruvbox_dark = {
          fg = config.palette.br_bg;
          bg = config.palette.bg;
          black = config.palette.bg2;
          red = config.palette.br_green;
          green = config.palette.br_red;
          yellow = config.palette.br_yellow;
          blue = config.palette.br_blue;
          magenta = config.palette.br_purple;
          cyan = config.palette.br_aqua;
          orange = config.palette.br_orange;
          white = config.palette.white;
        };
      };
    };
  };
  # home.file.".config/zellij/layouts/supa.kdl".text = # kdl
  #   ''
  #     layout {
  #         default_tab_template {
  #             children
  #             pane size=1 borderless=true {
  #                 plugin location=${supabar-wasm}
  #             }
  #         }

  #       tab_template name="ui" {
  #          children
  #          pane size=1 borderless=true {
  #             plugin location=${supabar-wasm}
  #          }
  #       }

  #       swap_tiled_layout name="vertical" {
  #           ui max_panes=4 {
  #               pane split_direction="vertical" {
  #                   pane
  #                   pane { children; }
  #               }
  #           }
  #           ui max_panes=7 {
  #               pane split_direction="vertical" {
  #                   pane { children; }
  #                   pane { pane; pane; pane; pane; }
  #               }
  #           }
  #           ui max_panes=11 {
  #               pane split_direction="vertical" {
  #                   pane { children; }
  #                   pane { pane; pane; pane; pane; }
  #                   pane { pane; pane; pane; pane; }
  #               }
  #           }
  #       }

  #       swap_tiled_layout name="horizontal" {
  #           ui max_panes=3 {
  #               pane
  #               pane
  #           }
  #           ui max_panes=7 {
  #               pane {
  #                   pane split_direction="vertical" { children; }
  #                   pane split_direction="vertical" { pane; pane; pane; pane; }
  #               }
  #           }
  #           ui max_panes=11 {
  #               pane {
  #                   pane split_direction="vertical" { children; }
  #                   pane split_direction="vertical" { pane; pane; pane; pane; }
  #                   pane split_direction="vertical" { pane; pane; pane; pane; }
  #               }
  #           }
  #       }

  #       swap_tiled_layout name="stacked" {
  #           ui min_panes=4 {
  #               pane split_direction="vertical" {
  #                   pane
  #                   pane stacked=true { children; }
  #               }
  #           }
  #       }

  #       swap_tiled_layout name="box" {
  #           ui max_panes=4 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=4 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=5 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=7 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=9 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=10 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #           ui max_panes=17 {
  #               pane split_direction="vertical" {
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #                   pane split_direction="horizontal" {
  #                       pane
  #                       pane
  #                       pane
  #                       pane
  #                   }
  #               }
  #           }
  #       }

  #       swap_floating_layout name="staggered" {
  #           floating_panes
  #       }

  #       swap_floating_layout name="enlarged" {
  #           floating_panes max_panes=10 {
  #               pane { x "5%"; y 1; width "90%"; height "90%"; }
  #               pane { x "5%"; y 2; width "90%"; height "90%"; }
  #               pane { x "5%"; y 3; width "90%"; height "90%"; }
  #               pane { x "5%"; y 4; width "90%"; height "90%"; }
  #               pane { x "5%"; y 5; width "90%"; height "90%"; }
  #               pane { x "5%"; y 6; width "90%"; height "90%"; }
  #               pane { x "5%"; y 7; width "90%"; height "90%"; }
  #               pane { x "5%"; y 8; width "90%"; height "90%"; }
  #               pane { x "5%"; y 9; width "90%"; height "90%"; }
  #               pane focus=true { x 10; y 10; width "90%"; height "90%"; }
  #           }
  #       }

  #       swap_floating_layout name="spread" {
  #           floating_panes max_panes=1 {
  #               pane {y "50%"; x "50%"; }
  #           }
  #           floating_panes max_panes=2 {
  #               pane { x "1%"; y "25%"; width "45%"; }
  #               pane { x "50%"; y "25%"; width "45%"; }
  #           }
  #           floating_panes max_panes=3 {
  #               pane focus=true { y "55%"; width "45%"; height "45%"; }
  #               pane { x "1%"; y "1%"; width "45%"; }
  #               pane { x "50%"; y "1%"; width "45%"; }
  #           }
  #           floating_panes max_panes=4 {
  #              pane { x "1%"; y "55%"; width "45%"; height "45%"; }
  #              pane focus=true { x "50%"; y "55%"; width "45%"; height "45%"; }
  #              pane { x "1%"; y "1%"; width "45%"; height "45%"; }
  #              pane { x "50%"; y "1%"; width "45%"; height "45%"; }
  #          }
  #       }

  #     }

  #   '';
}
