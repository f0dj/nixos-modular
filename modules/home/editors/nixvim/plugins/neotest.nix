/**
 * @file: modules/home/editors/nixvim/plugins/neotest.nix
 * @purpose: neotest configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.neotest;
in
{
  options.my.editors.nixvim.plugins.neotest = {
    enable = lib.mkEnableOption "neotest plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.neotest = {
        enable = true;
        package = pkgs.vimPlugins.neotest.overrideAttrs (old: {
          # FIXME(gambiarra): Disable tests as they are failing in the Nix sandbox after flake update
          # TODO(config): Investigate root cause of sandbox test failures and re-enable.
          doCheck = false;
          checkPhase = "";
        });
        adapters.golang = {
          enable = true;
          settings = {
            dap_go_enabled = true;
            testify_enabled = false;
            warn_test_name_dupes = true;
            warn_test_not_executed = true;
            args = [
              "-v"
              "-race"
              "-count=1"
            ];
          };
        };
        adapters.jest = {
          enable = true;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        FixCursorHold-nvim
      ];

      keymaps = [
        {
          mode = "n";
          key = "<leader>ta";
          action = ":lua require('neotest').run.attach()<CR>";
          options = {
            silent = true;
            desc = "[t]est [a]ttach";
          };
        }
        {
          mode = "n";
          key = "<leader>tf";
          action = ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
          options = {
            silent = true;
            desc = "[t]est run [f]ile";
          };
        }
        {
          mode = "n";
          key = "<leader>tA";
          action = ":lua require('neotest').run.run(vim.uv.cwd())<CR>";
          options = {
            silent = true;
            desc = "[t]est [A]ll files";
          };
        }
        {
          mode = "n";
          key = "<leader>tS";
          action = ":lua require('neotest').run.run({ suite = true })<CR>";
          options = {
            silent = true;
            desc = "[t]est [S]uite";
          };
        }
        {
          mode = "n";
          key = "<leader>tn";
          action = ":lua require('neotest').run.run()<CR>";
          options = {
            silent = true;
            desc = "[t]est [n]earest";
          };
        }
        {
          mode = "n";
          key = "<leader>tl";
          action = ":lua require('neotest').run.run_last()<CR>";
          options = {
            silent = true;
            desc = "[t]est [l]ast";
          };
        }
        {
          mode = "n";
          key = "<leader>ts";
          action = ":lua require('neotest').summary.toggle()<CR>";
          options = {
            silent = true;
            desc = "[t]est [s]ummary";
          };
        }
        {
          mode = "n";
          key = "<leader>to";
          action = ":lua require('neotest').output.open({ enter = true, auto_close = true })<CR>";
          options = {
            silent = true;
            desc = "[t]est [o]utput";
          };
        }
        {
          mode = "n";
          key = "<leader>tO";
          action = ":lua require('neotest').output_panel.toggle()<CR>";
          options = {
            silent = true;
            desc = "[t]est [O]utput panel";
          };
        }
        {
          mode = "n";
          key = "<leader>tt";
          action = ":lua require('neotest').run.stop()<CR>";
          options = {
            silent = true;
            desc = "[t]est [t]erminate";
          };
        }
        {
          mode = "n";
          key = "<leader>td";
          action = ":lua require('neotest').run.run({ suite = false, strategy = 'dap' })<CR>";
          options = {
            silent = true;
            desc = "Debug nearest test";
          };
        }
      ];
    };
  };
}
