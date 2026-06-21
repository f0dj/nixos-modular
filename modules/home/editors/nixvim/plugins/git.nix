/**
 * @file: modules/home/editors/nixvim/plugins/git.nix
 * @purpose: Git-related plugins configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:
let
  cfg = config.my.editors.nixvim.plugins.git;
in
{
  options.my.editors.nixvim.plugins.git = {
    enable = lib.mkEnableOption "Git plugins (gitsigns, diffview, gitlinker)";
    gitsigns.enable = lib.mkEnableOption "Gitsigns plugin for NixVim";
    diffview.enable = lib.mkEnableOption "Diffview plugin for NixVim";
    gitlinker.enable = lib.mkEnableOption "Gitlinker plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins = {
        gitsigns = lib.mkIf cfg.gitsigns.enable {
          enable = true;
          settings = {
            trouble = true;
            current_line_blame = true;
            signs = {
              add.text = "│";
              change.text = "│";
              delete.text = "_";
              topdelete.text = "‾";
              changedelete.text = "~";
              untracked.text = "┆";
            };
          };
        };

        diffview = lib.mkIf cfg.diffview.enable {
          enable = true;
        };

        gitlinker = lib.mkIf cfg.gitlinker.enable {
          enable = true;
          settings = {
            callbacks = {
              "github.com" = { __raw = "require('gitlinker.hosts').get_github_type_url"; };
              "gitlab.dnm.radiofrance.fr" = { __raw = "require('gitlinker.hosts').get_github_type_url"; };
            };
          };
        };
      };

      keymaps = lib.mkIf cfg.gitsigns.enable [
        {
          mode = [ "n" "v" ];
          key = "<leader>gh";
          action = "gitsigns";
          options = {
            silent = true;
            desc = "+hunks";
          };
        }
        {
          mode = "n";
          key = "<leader>ghb";
          action = ":Gitsigns blame_line<CR>";
          options = {
            silent = true;
            desc = "Blame line";
          };
        }
        {
          mode = "n";
          key = "<leader>ghd";
          action = ":Gitsigns diffthis<CR>";
          options = {
            silent = true;
            desc = "Diff This";
          };
        }
        {
          mode = "n";
          key = "<leader>rr";
          action = ":Gitsigns reset_hunk<CR>";
          options = {
            silent = true;
            desc = "Reset hunk";
          };
        }
        {
          mode = "n";
          key = "<leader>gr";
          action = ":Gitsigns reset_buffer<CR>";
          options = {
            silent = true;
            desc = "Reset Buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>ghS";
          action = ":Gitsigns stage_buffer<CR>";
          options = {
            silent = true;
            desc = "Stage Buffer";
          };
        }
        {
          mode = "n";
          key = "<leader>gn";
          action = ":Gitsigns next_hunk<CR>";
          options = {
            silent = true;
            desc = "Next Hunk";
          };
        }
        {
          mode = "n";
          key = "<leader>gp";
          action = ":Gitsigns prev_hunk<CR>";
          options = {
            silent = true;
            desc = "Prev Hunk";
          };
        }
        {
          mode = "n";
          key = "[c";
          action = ":Gitsigns next_hunk<CR>";
          options = {
            silent = true;
            desc = "Next Hunk";
          };
        }
        {
          mode = "n";
          key = "]c";
          action = ":Gitsigns prev_hunk<CR>";
          options = {
            silent = true;
            desc = "Prev Hunk";
          };
        }
      ];
    };
  };
}
