/**
 * @file: modules/home/editors/nixvim/plugins/dap.nix
 * @purpose: Debug Adapter Protocol (DAP) configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.dap;
in
{
  options.my.editors.nixvim.plugins.dap = {
    enable = lib.mkEnableOption "DAP plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins = {
        dap = {
          enable = true;
        };
        dap-go.enable = true;
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };

      extraPlugins = with pkgs.vimPlugins; [
        nvim-dap-vscode-js
      ];

      globals = {
        nodejs_bin = "${pkgs.nodejs}/bin/node";
        vscode_js_debug_path = "${pkgs.vscode-js-debug}";
      };

      extraConfigLua = ''
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup({})

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end

        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "DapStoppedLine", numhl = "DapStoppedLine" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })

        -- Configure js-debug server
        dap.adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = 9123,
          executable = {
            command = "node",
            args = {
              vim.g.vscode_js_debug_path .. "/lib/node_modules/js-debug/dist/src/dapDebugServer.js",
              "9123"
            }
          }
        }

        -- Configure adapters with aliases
        dap.adapters["node"] = dap.adapters["pwa-node"]
        dap.adapters["pwa-chrome"] = dap.adapters["pwa-node"]
        dap.adapters["chrome"] = dap.adapters["pwa-node"]
        dap.adapters["pwa-msedge"] = dap.adapters["pwa-node"]
        dap.adapters["node-terminal"] = dap.adapters["pwa-node"]
      '';

      keymaps = [
        # DAP
        {
          mode = "n";
          key = "<leader>db";
          action = ":lua require('dap').toggle_breakpoint()<CR>";
          options.desc = "toggle [d]ebug [b]reakpoint";
        }
        {
          mode = "n";
          key = "<leader>dB";
          action = ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>";
          options.desc = "[d]ebug [B]reakpoint";
        }
        {
          mode = "n";
          key = "<leader>dc";
          action = ":lua require('dap').continue()<CR>";
          options.desc = "[d]ebug [c]ontinue (start here)";
        }
        {
          mode = "n";
          key = "<leader>dC";
          action = ":lua require('dap').run_to_cursor()<CR>";
          options.desc = "[d]ebug [C]ursor";
        }
        {
          mode = "n";
          key = "<leader>dg";
          action = ":lua require('dap').goto_()<CR>";
          options.desc = "[d]ebug [g]o to line";
        }
        {
          mode = "n";
          key = "<leader>do";
          action = ":lua require('dap').step_over()<CR>";
          options.desc = "[d]ebug step [o]ver";
        }
        {
          mode = "n";
          key = "<leader>dO";
          action = ":lua require('dap').step_out()<CR>";
          options.desc = "[d]ebug step [O]ut";
        }
        {
          mode = "n";
          key = "<leader>di";
          action = ":lua require('dap').step_into()<CR>";
          options.desc = "[d]ebug [i]nto";
        }
        {
          mode = "n";
          key = "<leader>dj";
          action = ":lua require('dap').down()<CR>";
          options.desc = "[d]ebug [j]ump down";
        }
        {
          mode = "n";
          key = "<leader>dk";
          action = ":lua require('dap').up()<CR>";
          options.desc = "[d]ebug [k]ump up";
        }
        {
          mode = "n";
          key = "<leader>dl";
          action = ":lua require('dap').run_last()<CR>";
          options.desc = "[d]ebug [l]ast";
        }
        {
          mode = "n";
          key = "<leader>dp";
          action = ":lua require('dap').pause()<CR>";
          options.desc = "[d]ebug [p]ause";
        }
        {
          mode = "n";
          key = "<leader>dr";
          action = ":lua require('dap').repl.toggle()<CR>";
          options.desc = "[d]ebug [r]epl";
        }
        {
          mode = "n";
          key = "<leader>dR";
          action = ":lua require('dap').clear_breakpoints()<CR>";
          options.desc = "[d]ebug [R]emove breakpoints";
        }
        {
          mode = "n";
          key = "<leader>ds";
          action = ":lua require('dap').session()<CR>";
          options.desc = "[d]ebug [s]ession";
        }
        {
          mode = "n";
          key = "<leader>dt";
          action = ":lua require('dap').terminate()<CR>";
          options.desc = "[d]ebug [t]erminate";
        }
        {
          mode = "n";
          key = "<leader>dw";
          action = ":lua require('dap.ui.widgets').hover()<CR>";
          options.desc = "[d]ebug [w]idgets";
        }

        # DAP UI keymaps
        {
          mode = "n";
          key = "<leader>du";
          action = ":lua require('dapui').toggle({})<CR>";
          options.desc = "[d]ap [u]i";
        }
        {
          mode = "n";
          key = "<leader>de";
          action = ":lua require('dapui').eval()<CR>";
          options.desc = "[d]ap [e]val";
        }

        # Load launch.json and run
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>da";
          action.__raw = ''
            function()
              if vim.fn.filereadable(".vscode/launch.json") then
                require("dap.ext.vscode").load_launchjs()
                print("Loaded launch.json")
              end
              require("dap").continue()
            end
          '';
          options.desc = "Debug with Launch.json";
        }
      ];
    };
  };
}
