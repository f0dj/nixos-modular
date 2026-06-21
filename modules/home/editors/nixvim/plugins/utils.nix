/**
 * @file: modules/home/editors/nixvim/plugins/utils.nix
 * @purpose: Utility plugins configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.utils;
in
{
  options.my.editors.nixvim.plugins.utils = {
    enable = lib.mkEnableOption "Utility plugins for NixVim";
    codecompanion.enable = lib.mkEnableOption "codecompanion plugin";
    comment-box.enable = lib.mkEnableOption "comment-box plugin";
    comment.enable = lib.mkEnableOption "comment plugin";
    oil.enable = lib.mkEnableOption "oil.nvim plugin";
    web-devicons.enable = lib.mkEnableOption "web-devicons plugin";
    which-key.enable = lib.mkEnableOption "which-key plugin";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins = {
        web-devicons.enable = cfg.web-devicons.enable;
        codecompanion = lib.mkIf cfg.codecompanion.enable {
          enable = true;
          settings = {
            adapters = {
              gemini.__raw = ''
                function()
                  return require('codecompanion.adapters').extend('gemini', {
                      schema = {
                          model = {
                            default = 'gemini-2.0-flash',
                          },
                          num_ctx = {
                              default = 32768,
                          },
                      },
                      env = {
                        api_key = "GEMINI_API_KEY",
                      },
                  })
                end
              '';
              deepseek.__raw = ''
                function()
                  return require('codecompanion.adapters').extend('openai', {
                      schema = {
                          model = {
                            default = 'deepseek-coder',
                          },
                          endpoint = {
                            default = 'https://api.deepseek.com',
                          },
                      },
                      env = {
                        api_key = "DEEPSEEK_API_KEY",
                      },
                  })
                end
              '';
            };
            strategies = {
              chat.adapter = "gemini";
              inline.adapter = "gemini";
              agent.adapter = "gemini";
            };
          };
        };

        comment-box.enable = cfg.comment-box.enable;
        comment.enable = cfg.comment.enable;

        oil = lib.mkIf cfg.oil.enable {
          enable = true;
          settings = {
            useDefaultKeymaps = true;
            deleteToTrash = true;
            float = {
              padding = 2;
              maxWidth = 0;
              maxHeight = 0;
              border = "rounded";
              winOptions = {
                winblend = 0;
              };
            };
            preview = {
              border = "rounded";
            };
            keymaps = {
              "g?" = "actions.show_help";
              "<CR>" = "actions.select";
              "<C-\\>" = "actions.select_vsplit";
              "<C-enter>" = "actions.select_split";
              "<C-t>" = "actions.select_tab";
              "<C-v>" = "actions.preview";
              "<C-c>" = "actions.close";
              "<C-r>" = "actions.refresh";
              "-" = "actions.parent";
              "_" = "actions.open_cwd";
              "`" = "actions.cd";
              "~" = "actions.tcd";
              "gs" = "actions.change_sort";
              "gx" = "actions.open_external";
              "g." = "actions.toggle_hidden";
              "q" = "actions.close";
            };
          };
        };

        which-key.enable = cfg.which-key.enable;
      };

      keymaps = (lib.optionals cfg.codecompanion.enable [
        {
          key = "<leader>cc";
          action = ":CodeCompanionChat<CR>";
          mode = "n";
          options = {
            silent = true;
            desc = "Toggle CodeCompanion";
          };
        }
        {
          key = "<leader>cf";
          action = ":CodeCompanionActions<CR>";
          mode = "n";
          options = {
            silent = true;
            desc = "CodeCompanion Actions";
          };
        }
      ]) ++ (lib.optionals cfg.oil.enable [
        {
          mode = "n";
          key = "-";
          action = ":Oil<CR>";
          options = {
            desc = "Open parent directory";
            silent = true;
          };
        }
      ]);
    };
  };
}
