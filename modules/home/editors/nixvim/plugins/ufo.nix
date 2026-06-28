/**
 * @file: modules/home/editors/nixvim/plugins/ufo.nix
 * @purpose: nvim-ufo configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.ufo;
in
{
  options.my.editors.nixvim.plugins.ufo = {
    enable = lib.mkEnableOption "nvim-ufo plugin for NixVim";
  };

  # Provides fold column with Treesitter-based code folding.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.nvim-ufo.enable = true;
  };
}
