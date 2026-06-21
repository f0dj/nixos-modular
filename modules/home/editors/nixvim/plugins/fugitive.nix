/**
 * @file: modules/home/editors/nixvim/plugins/fugitive.nix
 * @purpose: Fugitive Git plugin configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.fugitive;
in
{
  options.my.editors.nixvim.plugins.fugitive = {
    enable = lib.mkEnableOption "Fugitive plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.fugitive = {
        enable = true;
      };

      keymaps = [
        {
          mode = "n";
          key = "<leader>gs";
          action = "<cmd>Git<CR>";
          options = {
            desc = "Git status";
          };
        }
        {
          mode = "n";
          key = "<leader>gd";
          action = "<cmd>Gdiffsplit<CR>";
          options = {
            desc = "Git diff split";
          };
        }
        {
          mode = "n";
          key = "<leader>gc";
          action = "<cmd>Git commit<CR>";
          options = {
            desc = "Git commit";
          };
        }
        {
          mode = "n";
          key = "<leader>gb";
          action = "<cmd>Git blame<CR>";
          options = {
            desc = "Git blame";
          };
        }
        {
          mode = "n";
          key = "<leader>gm";
          action = "<cmd>Git mergetool<CR>";
          options = {
            desc = "Git mergetool";
          };
        }
      ];
    };
  };
}
