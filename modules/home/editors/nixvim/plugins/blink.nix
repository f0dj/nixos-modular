/**
 * @file: modules/home/editors/nixvim/plugins/blink.nix
 * @purpose: Blink-cmp configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.blink;
in
{
  options.my.editors.nixvim.plugins.blink = {
    enable = lib.mkEnableOption "Blink-cmp plugin for NixVim";
  };

  # LSP-first completion engine with ripgrep fallback and Nerd Font icons.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        blink-ripgrep-nvim
      ];

      extraPackages = with pkgs; [
        gh
      ];

      plugins.blink-cmp = {
        enable = true;
        setupLspCapabilities = true;

        settings = {
          keymap = {
            preset = "default";
            "<CR>" = [
              "select_and_accept"
              "fallback"
            ];
            "<Up>" = [
              "select_prev"
              "fallback"
            ];
            "<Down>" = [
              "select_next"
              "fallback"
            ];
          };
          signature = {
            enabled = true;
          };

          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
            ];
            providers = {
              lsp.score_offset = 1;
            };
          };

          appearance = {
            nerd_font_variant = "mono";
            kind_icons = {
              Text = "󰉿";
              Method = "";
              Function = "󰊕";
              Constructor = "󰒓";

              Field = "󰜢";
              Variable = "󰆦";
              Property = "󰖷";

              Class = "󱡠";
              Interface = "󱡠";
              Struct = "󱡠";
              Module = "󰅩";

              Unit = "󰪚";
              Value = "󰦨";
              Enum = "󰦨";
              EnumMember = "󰦨";

              Keyword = "󰻾";
              Constant = "󰏿";

              Snippet = "󱄽";
              Color = "󰏘";
              File = "󰈔";
              Reference = "󰬲";
              Folder = "󰉋";
              Event = "󱐋";
              Operator = "󰪚";
              TypeParameter = "󰬛";
              Error = "󰏭";
              Warning = "󰏯";
              Information = "󰏮";
              Hint = "󰏭";

              Emoji = "🤶";
            };
          };
          completion = {
            menu = {
              border = "none";
              draw = {
                gap = 1;
                treesitter = [ "lsp" ];
                columns = [
                  {
                    __unkeyed-1 = "label";
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                  { __unkeyed-1 = "source_name"; }
                ];
              };
            };
            trigger = {
              show_in_snippet = false;
            };
            documentation = {
              auto_show = true;
              window = {
                border = "single";
              };
            };
            accept = {
              auto_brackets = {
                enabled = false;
              };
            };
          };
        };
      };
    };
  };
}
