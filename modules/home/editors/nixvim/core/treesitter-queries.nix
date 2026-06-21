/**
 * @file: modules/home/editors/nixvim/core/treesitter-queries.nix
 * @purpose: Custom Treesitter queries for NixVim.
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
      extraFiles = {
        "after/queries/typescript/highlights.scm" = {
          text = ''
            ; This should make ALL identifiers red - very obvious test
            ((identifier) @error)
          '';
        };
      };
    };
  };
}
