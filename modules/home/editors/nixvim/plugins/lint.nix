/**
 * @file: modules/home/editors/nixvim/plugins/lint.nix
 * @purpose: Nvim-lint configuration for NixVim.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:
let
  cfg = config.my.editors.nixvim.plugins.lint;
in
{
  options.my.editors.nixvim.plugins.lint = {
    enable = lib.mkEnableOption "Nvim-lint plugin for NixVim";
  };

  config = lib.mkIf (config.my.editors.nixvim.enable && cfg.enable) {
    programs.nixvim = {
      plugins.lint = {
        enable = true;
        lazyLoad = {};

        lintersByFt = {
          bash = [ "shellcheck" ];
          fish = [ "fish" ];
          go = [ "golangcilint" ];
          json = [ "jq" ];
          lua = [ "luacheck" ];
          markdown = [ "markdownlint" ];
          python = [ "ruff" ];
          nix = [
            "deadnix"
            "nix"
            "statix"
          ];
          sh = [ "shellcheck" ];
          terraform = [ "tflint" ];
          yaml = [ "yamllint" ];
        };

        linters = {
          checkmake.cmd = lib.getExe pkgs.checkmake;
          deadnix.cmd = lib.getExe pkgs.deadnix;
          fish.cmd = lib.getExe pkgs.fish;
          golangcilint.cmd = lib.getExe pkgs.golangci-lint;
          jq.cmd = lib.getExe pkgs.jq;
          luacheck.cmd = lib.getExe pkgs.luaPackages.luacheck;
          markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
          ruff.cmd = lib.getExe pkgs.ruff;
          pylint.cmd = lib.getExe pkgs.pylint;
          shellcheck.cmd = lib.getExe pkgs.shellcheck;
          sqlfluff.cmd = lib.getExe pkgs.sqlfluff;
          statix.cmd = lib.getExe pkgs.statix;
          tflint.cmd = lib.getExe pkgs.tflint;
          yamllint.cmd = lib.getExe pkgs.yamllint;
        };
      };
    };
  };
}
