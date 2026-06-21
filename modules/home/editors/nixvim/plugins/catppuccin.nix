/**
 * @file: modules/home/editors/nixvim/plugins/catppuccin.nix
 * @purpose: Catppuccin colorscheme configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.catppuccin;
in
{
  options.my.editors.nixvim.plugins.catppuccin = {
    enable = lib.mkEnableOption "Catppuccin colorscheme for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      colorschemes.catppuccin = {
        enable = true;
        settings = {
          default_integrations = true;
          dim_inactive = {
            enabled = false;
            percentage = 0.25;
          };

          flavour = "frappe";
          background = {
            dark = "frappe";
            light = "latte";
          };

          color_overrides = {
            latte = {
              #Base
              maroon = "#F29BA7";
              teal = "#9cd1bb";
              sky = "#A6C9E5";
              sapphire = "#86AACC";
              blue = "#5d81ab";
              lavender = "#66729C";

              text = "#202027";
              subtext1 = "#263168";
              subtext0 = "#4c4f69";
              overlay2 = "#737994";
              overlay1 = "#838ba7";
              base = "#fcfcfa";
              mantle = "#EAEDF3";
              crust = "#DCE0E8";
              pink = "#EA7A95";
              mauve = "#986794";
              red = "#EC5E66";
              peach = "#FF8459";
              yellow = "#CAA75E";
              green = "#87A35E";
            };
            frappe = {
              #Base
              red = "#ff657a";
              maroon = "#F29BA7";
              peach = "#ff9b5e";
              yellow = "#eccc81";
              green = "#a8be81";
              teal = "#9cd1bb";
              sky = "#A6C9E5";
              sapphire = "#86AACC";
              blue = "#e6e6e6"; # Changed to white/grey
              lavender = "#66729C";
              mauve = "#b18eab";

              text = "#fcfcfa";
              surface2 = "#535763";
              surface1 = "#3a3d4b";
              surface0 = "#30303b";
              base = "#202027";
              mantle = "#1c1d22";
              crust = "#171719";
            };
          };

          custom_highlights = {
            SnacksIndentScope = {
              fg = "#e1e1e1";
            };

            SnacksIndent1 = {
              fg = "#1e1e2e"; # Replace with your actual background color
            };

            SnacksIndent2 = {
              fg = "#1e1e2e"; # Replace with your actual background color
            };

            GitSignsAdd = {
              fg = "#6d5cb8";
            };

            GitSignsChange = {
              fg = "#ddba6e";
            };

            GitSignsCurrentLineBlame = {
              fg = "#666e7f";
            };

            LineNR = {
              fg = "#8491b3";
            };

            CursorLineNR = {
              fg = "#b0c0e8";
            };

            CursorLine = {
              bg = "#393d47";
            };

            "CustomLoggerVar" = {
              fg = "#e6e6e6";
              style = [ "bold" ];
            };

            "CustomLoggerMethod" = {
              fg = "#9cd1bb";
              style = [ "bold" ];
            };

          };

          integrations = {
            aerial = true;
            blink_cmp = true;
            dap = {
              enabled = true;
              enable_ui = true;
            };
            indent_blankline = {
              enabled = true;
              colored_indent_levels = true;
            };
            lsp_trouble = true;
            markdown = true;
            mason = true;
            mini.enabled = true;

            native_lsp = {
              enabled = true;
              virtual_text = {
                errors = [ "italic" ];
                hints = [ "italic" ];
                warnings = [ "italic" ];
                information = [ "italic" ];
              };
              underlines = {
                errors = [ "underline" ];
                hints = [ "underline" ];
                warnings = [ "underline" ];
                information = [ "underline" ];
              };
              inlay_hints = {
                background = true;
              };
            };
            noice = true;
            notify = true;
            symbols_outline = true;
            snacks = true;
            treesitter = true;
          };

          show_end_of_buffer = true;
          term_colors = true;
          transparent_background = true;
        };
      };
    };
  };
}
