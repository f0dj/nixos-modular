/**
 * @file: modules/home/editors/nixvim/plugins/indent.nix
 * @purpose: Indent-blankline configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.indent;
in
{
  options.my.editors.nixvim.plugins.indent = {
    enable = lib.mkEnableOption "Indent-blankline plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.indent-blankline = {
        # Preserve original disabled state if it was false in original config
        # though the user might want to enable it via options now.
        # Original had enable = false;
        enable = false; 
        settings = {
          indent = {
            char = "▏";
          };
          scope = {
            enabled = false;
          };
          exclude = {
            filetypes = [
              "help"
              "terminal"
              "dashboard"
            ];
          };
        };
      };
    };
  };
}
