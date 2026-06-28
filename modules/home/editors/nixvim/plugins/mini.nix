/**
 * @file: modules/home/editors/nixvim/plugins/mini.nix
 * @purpose: mini.nvim configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.mini;
in
{
  options.my.editors.nixvim.plugins.mini = {
    enable = lib.mkEnableOption "mini.nvim plugins for NixVim";
  };

  # Auto-closes brackets, quotes, and other paired characters.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.mini = {
      enable = true;
      modules = {
        pairs = { };
      };
    };
  };
}
