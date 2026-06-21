/**
 * @file: modules/home/editors/nixvim/plugins/supermaven.nix
 * @purpose: supermaven configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.supermaven;
in
{
  options.my.editors.nixvim.plugins.supermaven = {
    enable = lib.mkEnableOption "supermaven plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.supermaven = {
      enable = true;
      settings = {
        keymaps = {
          accept_suggestion = "<Tab>";
          clear_suggestions = "<C-]>";
          accept_word = "<C-j>";
        };
        color = {
          suggestion_color = "#9ba2c2";
          cterm = 244;
        };
        log_level = "info";
        disable_inline_completion = false;
        disable_keymaps = false;
      };
    };
  };
}
