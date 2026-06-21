/**
 * @file: modules/home/editors/nixvim/plugins/trouble.nix
 * @purpose: trouble.nvim configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.trouble;
in
{
  options.my.editors.nixvim.plugins.trouble = {
    enable = lib.mkEnableOption "trouble.nvim plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.trouble.enable = true;
  };
}
