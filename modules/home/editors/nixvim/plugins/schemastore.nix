/**
 * @file: modules/home/editors/nixvim/plugins/schemastore.nix
 * @purpose: schemastore configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.schemastore;
in
{
  options.my.editors.nixvim.plugins.schemastore = {
    enable = lib.mkEnableOption "schemastore plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.schemastore = {
      enable = true;
      yaml.enable = true;
      json.enable = false;
    };
  };
}
