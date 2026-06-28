/**
 * @file: modules/home/editors/nixvim/plugins/lz-n.nix
 * @purpose: lz-n (lazy loading) configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.lz-n;
in
{
  options.my.editors.nixvim.plugins.lz-n = {
    enable = lib.mkEnableOption "lz-n plugin for NixVim";
  };

  # Lazy-loads plugins on keypress or event to reduce startup time.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.lz-n.enable = true;
  };
}
