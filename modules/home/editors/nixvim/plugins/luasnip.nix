/**
 * @file: modules/home/editors/nixvim/plugins/luasnip.nix
 * @purpose: Luasnip configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.luasnip;
in
{
  options.my.editors.nixvim.plugins.luasnip = {
    enable = lib.mkEnableOption "Luasnip plugin for NixVim";
  };

  # Snippet engine with VSCode snippet compatibility and auto-snippets.
  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.luasnip = {
        enable = true;
        settings = {
          enable_autosnippets = true;
          store_selection_keys = "<Tab>";
        };
        fromVscode = [
          {
            lazyLoad = true;
            paths = "${pkgs.vimPlugins.friendly-snippets}";
          }
        ];
      };
    };
  };
}
