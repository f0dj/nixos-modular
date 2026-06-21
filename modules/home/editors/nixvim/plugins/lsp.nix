/**
 * @file: modules/home/editors/nixvim/plugins/lsp.nix
 * @purpose: LSP-related plugins configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.lsp;
in
{
  options.my.editors.nixvim.plugins.lsp = {
    enable = lib.mkEnableOption "LSP configuration for NixVim";
    lspsaga.enable = lib.mkEnableOption "Lspsaga plugin for NixVim";
    lsp-lines.enable = lib.mkEnableOption "LSP-lines plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      extraPackages = with pkgs; [
        bash-language-server
        julia-bin
        marksman
        vscode-langservers-extracted
        texlab
      ];
      plugins = {
        lsp-format.enable = false;
        lsp = {
          enable = true;
          inlayHints = true;
          servers = {
            bashls.enable = true;
            clangd.enable = true;
            html.enable = true;
            jsonls.enable = true;
            julials = {
              enable = true;
              package = null;
            };
            lua_ls.enable = true;
            nixd.enable = true;
            marksman.enable = true;
            pyright.enable = true;
            gopls.enable = true;
            terraformls.enable = true;
            texlab.enable = true;
            ruff.enable = true;
            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };
            yamlls.enable = true;
            elixirls.enable = true;
            ts_ls.enable = true;
            sourcekit.enable = false;
            kotlin_language_server.enable = true;
          };
          keymaps = {
            silent = true;
            lspBuf = {
              gld = {
                action = "definition";
                desc = "Goto Definition";
              };
              glr = {
                action = "references";
                desc = "Goto References";
              };
              glD = {
                action = "declaration";
                desc = "Goto Declaration";
              };
              glI = {
                action = "implementation";
                desc = "Goto Implementation";
              };
              glT = {
                action = "type_definition";
                desc = "Type Definition";
              };
              "<leader>cw" = {
                action = "workspace_symbol";
                desc = "Workspace Symbol";
              };
              "<leader>cr" = {
                action = "rename";
                desc = "Rename";
              };
            };
            diagnostic = {
              "<leader>cd" = {
                action = "open_float";
                desc = "Line Diagnostics";
              };
              "[d" = {
                action = "goto_next";
                desc = "Next Diagnostic";
              };
              "]d" = {
                action = "goto_prev";
                desc = "Previous Diagnostic";
              };
            };
          };
        };

        lspsaga = lib.mkIf cfg.lspsaga.enable {
          enable = true;
          settings = {
            beacon.enable = true;
            ui = {
              border = "rounded";
              code_action = "💡";
            };
            hover = {
              open_cmd = "!floorp";
              open_link = "gx";
            };
            diagnostic = {
              border_follow = true;
              diagnostic_only_current = false;
              show_code_action = true;
            };
            symbol_in_winbar.enable = true;
            code_action = {
              extend_git_signs = false;
              show_server_name = true;
              only_in_cursor = true;
              num_shortcut = true;
              keys = {
                exec = "<CR>";
                quit = [ "<Esc>" "q" ];
              };
            };
            lightbulb = {
              enable = false;
              sign = false;
              virtual_text = true;
            };
            implement.enable = false;
            rename = {
              auto_save = false;
              keys = {
                exec = "<CR>";
                quit = [ "<C-k>" "<Esc>" ];
                select = "x";
              };
            };
            outline = {
              auto_close = true;
              auto_preview = true;
              close_after_jump = true;
              layout = "normal";
              win_position = "right";
              keys = {
                jump = "e";
                quit = "q";
                toggle_or_jump = "o";
              };
            };
            scroll_preview = {
              scroll_down = "<C-f>";
              scroll_up = "<C-b>";
            };
          };
        };

        lsp-lines = lib.mkIf cfg.lsp-lines.enable {
          enable = false; # Original was false
        };
      };

      keymaps = lib.mkIf cfg.lspsaga.enable [
        {
          mode = "n";
          key = "<leader>lo";
          action = "<cmd>Lspsaga outline<CR>";
          options = {
            desc = "Lspsaga outline";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "gd";
          action = "<cmd>Lspsaga goto_definition<CR>";
          options = {
            desc = "Goto Definition";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "gr";
          action = "m'<cmd>Lspsaga finder ref<CR>";
          options = {
            desc = "Goto References";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "gI";
          action = "m'<cmd>Lspsaga finder imp<CR>";
          options = {
            desc = "Goto Implementation";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "gT";
          action = "<cmd>Lspsaga peek_type_definition<CR>";
          options = {
            desc = "Type Definition";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "K";
          action = "<cmd>Lspsaga hover_doc<CR>";
          options = {
            desc = "Hover";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>cr";
          action = "<cmd>Lspsaga rename<CR>";
          options = {
            desc = "Rename";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>ca";
          action = "<cmd>Lspsaga code_action<CR>";
          options = {
            desc = "Code Action";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>cd";
          action = "<cmd>Lspsaga show_line_diagnostics<CR>";
          options = {
            desc = "Line Diagnostics";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "[d";
          action = "<cmd>Lspsaga diagnostic_jump_next<CR>";
          options = {
            desc = "Next Diagnostic";
            silent = true;
          };
        }
        {
          mode = "n";
          key = "]d";
          action = "<cmd>Lspsaga diagnostic_jump_prev<CR>";
          options = {
            desc = "Previous Diagnostic";
            silent = true;
          };
        }
      ];

      extraConfigLua = ''
        local _border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
          config = config or {}
          config.border = _border
          return vim.lsp.handlers.hover(_, result, ctx, config)
        end

        vim.lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
          config = config or {}
          config.border = _border
          return vim.lsp.handlers.signature_help(_, result, ctx, config)
        end

        require('lspconfig.ui.windows').default_options = {
          border = _border
        }

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = false
        
        if vim.lsp.config and vim.lsp.enable then
          ${lib.optionalString config.programs.nixvim.plugins.lsp.servers.gopls.enable ''
          vim.lsp.config('gopls', {
            capabilities = capabilities,
          })
          vim.lsp.enable('gopls')
          ''}
          
          ${lib.optionalString (config.programs.nixvim.plugins.lsp.servers ? zls && config.programs.nixvim.plugins.lsp.servers.zls.enable) ''
          vim.lsp.config('zls', {
            capabilities = capabilities,
            flags = {
              debounce_text_changes = 150,
            }
          })
          vim.lsp.enable('zls')
          ''}
          
          ${lib.optionalString config.programs.nixvim.plugins.lsp.servers.rust_analyzer.enable ''
          vim.lsp.config('rust_analyzer', {
            capabilities = capabilities,
          })
          vim.lsp.enable('rust_analyzer')
          ''}
          
          ${lib.optionalString config.programs.nixvim.plugins.lsp.servers.clangd.enable ''
          vim.lsp.config('clangd', {
            cmd = { "clangd", "--offset-encoding=utf-16" },
          })
          vim.lsp.enable('clangd')
          ''}
        end
      '';
    };
  };
}
