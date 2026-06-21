/**
 * @file: modules/home/editors/nixvim/core/autocmd.nix
 * @purpose: Neovim autocommands for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim;
in
{
  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      autoCmd = [
        # Vertically center document when entering insert mode
        {
          event = "InsertEnter";
          command = "norm zz";
        }

        # Open help in a vertical split
        {
          event = "FileType";
          pattern = "help";
          command = "wincmd L";
        }

        # Close Telescope prompt in insert mode by clicking escape
        {
          event = [ "FileType" ];
          pattern = "TelescopePrompt";
          command = "inoremap <buffer><silent> <ESC> <ESC>:close!<CR>";
        }

        # Enable spellcheck for some filetypes
        {
          event = "FileType";
          pattern = [
            "tex"
            "latex"
            "markdown"
          ];
          command = "setlocal spell spelllang=en,fr";
        }
        # Hilight yank text
        {
          event = "TextYankPost";
          pattern = "*";
          command = "lua vim.highlight.on_yank{timeout=500}";
        }
        # Enter git buffer in insert mode
        {
          event = "FileType";
          pattern = [
            "gitcommit"
            "gitrebase"
          ];
          command = "startinsert | 1";
        }

      ];
    };
  };
}
