/**
 * @file: modules/home/editors/nixvim/plugins/conform.nix
 * @purpose: Conform.nvim configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.conform;
in
{
  options.my.editors.nixvim.plugins.conform = {
    enable = lib.mkEnableOption "Conform.nvim plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      extraPackages = with pkgs; [
        shfmt
        nixfmt
        stylua
        ruff
        prettier
        prettierd
        yamlfmt
      ];
      plugins.conform-nvim = {
        enable = true;

        lazyLoad.settings = {
          cmd = [
            "ConformInfo"
            "ConformFormat"
          ];
          event = [
            "BufRead"
            "BufNewFile"
          ];
        };

        settings = {
          notify_on_error = true;

          formatters_by_ft = {
            python = [ "ruff_format" ];
            go = [
              "goimports"
              "gofmt"
            ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            markdown = [ "prettier" ];
            json = [ "prettier" ];
            yaml = [ "yamlfmt" ];
            javascript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            javascriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescript = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            typescriptreact = {
              __unkeyed-1 = "prettierd";
              __unkeyed-2 = "prettier";
              stop_after_first = true;
            };
            terragrunt = [
              "hcl"
            ];
            bash = [
              "shfmt"
            ];
          };
        };
      };

      keymaps = [
        {
          mode = [
            "n"
            "v"
          ];
          key = "<leader>ff";
          action = "<cmd>lua require('conform').format({ lsp_fallback = true })<cr>";
          options.desc = "Format buffer";
        }
      ];
    };
  };
}
