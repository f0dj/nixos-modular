/**
 * @file: modules/home/editors/nixvim/plugins/treesitter.nix
 * @purpose: Treesitter configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.treesitter;
in
{
  options.my.editors.nixvim.plugins.treesitter = {
    enable = lib.mkEnableOption "Treesitter plugin for NixVim";
    textobjects.enable = lib.mkEnableOption "Treesitter textobjects plugin";
  };

  # Syntax highlighting, indentation, folding, and text-object navigation via Tree-sitter.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.treesitter = {
        enable = true;

        settings = {
          indent = {
            enable = true;
          };
          highlight = {
            enable = true;
          };
        };

        folding.enable = true;
        nixvimInjections = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
      };

      plugins.treesitter-textobjects = lib.mkIf cfg.textobjects.enable {
        enable = true;
        settings = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "aa" = "@parameter.outer";
              "ia" = "@parameter.inner";
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
              "ii" = "@conditional.inner";
              "ai" = "@conditional.outer";
              "il" = "@loop.inner";
              "al" = "@loop.outer";
              "at" = "@comment.outer";
            };
          };
          move = {
            enable = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
          swap = {
            enable = true;
            swap_next = {
              "<leader>a" = "@parameters.inner";
            };
            swap_previous = {
              "<leader>A" = "@parameter.outer";
            };
          };
          lsp_interop = {
            enable = true;
            border = "single";
            peek_definition_code = {
              "<leader>df" = {
                query = "@function.outer";
                desc = "Peek definition outer function";
              };
              "<leader>dF" = {
                query = "@class.outer";
                desc = "Peek definition outer class";
              };
            };
          };
        };
      };
    };
  };
}
