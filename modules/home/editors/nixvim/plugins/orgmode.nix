/**
 * @file: modules/home/editors/nixvim/plugins/orgmode.nix
 * @purpose: Orgmode configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.orgmode;
in
{
  options.my.editors.nixvim.plugins.orgmode = {
    enable = lib.mkEnableOption "Orgmode plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim.plugins.orgmode = {
      enable = true;
      settings = {
        org_agenda_files = [ "~/Org/**/*" ];
        org_default_notes_file = "~/Org/notes.org";
      };
    };
  };
}
