/**
 * @file: modules/home/editors/nixvim/plugins/noice.nix
 * @purpose: noice.nvim configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.noice;
in
{
  options.my.editors.nixvim.plugins.noice = {
    enable = lib.mkEnableOption "noice.nvim plugin for NixVim";
  };

  # Replaces Neovim's built-in command-line and message UI with floating windows.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.nui.enable = true;

      extraPlugins = [
        (pkgs.vimUtils.buildVimPlugin {
          pname = "noice-fork";
          version = "custom";
          src = pkgs.fetchFromGitHub {
            owner = "axlEscalada";
            repo = "noice.nvim";
            rev = "5a981b5505a345e9863fceb66f093915ea3d0506";
            hash = "sha256-i/nRHndInloa1HcNtAPqfP5eK+s+Zqq3dcOeeaJObuY=";
          };
          dependencies = with pkgs.vimPlugins; [
            nui-nvim
            nvim-notify
          ];
        })
      ];

      extraConfigLua = ''
        require("noice").setup({
          notify = {
            enabled = false,
            view = "notify",
          },
          messages = {
            enabled = true,
            view = "mini",
          },
          lsp = {
            message = {
              enabled = false,
            },
            progress = {
              enabled = false,
              view = "mini",
            },
          },
          popupmenu = {
            enabled = true,
            backend = "nui",
          },
          cmdline = {
            view = "cmdline",
            format = {
              cmdline = {
                pattern = "^:",
                icon = ":",
                lang = "vim",
              },
            },
          },
        })
      '';
    };
  };
}
