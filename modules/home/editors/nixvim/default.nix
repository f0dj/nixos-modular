/**
 * @file: modules/home/editors/nixvim/default.nix
 * @purpose: Main orchestrator for the modular NixVim configuration.
 * @type: Module
 * @namespace: my
 */
{ config, lib, inputs, ... }:
let
  cfg = config.my.editors.nixvim;
in
{
  options.my.editors.nixvim = {
    enable = lib.mkEnableOption "NixVim configuration";
  };

  imports = [
    inputs.nixvim.homeModules.nixvim
    ./core/sets.nix
    ./core/keys.nix
    ./core/autocmd.nix
    ./core/treesitter-queries.nix
    ./plugins/avante.nix
    ./plugins/blink.nix
    ./plugins/bufferline.nix
    ./plugins/catppuccin.nix
    ./plugins/conform.nix
    ./plugins/dap.nix
    ./plugins/fzf-lua.nix
    ./plugins/fugitive.nix
    ./plugins/git.nix
    ./plugins/indent.nix
    ./plugins/lint.nix
    ./plugins/lsp.nix
    ./plugins/lualine.nix
    ./plugins/luasnip.nix
    ./plugins/lz-n.nix
    ./plugins/mini.nix
    ./plugins/neotest.nix
    ./plugins/noice.nix
    ./plugins/orgmode.nix
    ./plugins/schemastore.nix
    ./plugins/snacks.nix
    ./plugins/supermaven.nix
    ./plugins/treesitter.nix
    ./plugins/trouble.nix
    ./plugins/ufo.nix
    ./plugins/utils.nix
  ];

  config = lib.mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      version.enableNixpkgsReleaseCheck = false;
      # ponytail: nixvim's pinned nixpkgs has a stdenv bootstrap
      # infinite recursion; follow main nixpkgs to avoid it
      nixpkgs.source = inputs.nixpkgs;
    };
    _module.args.inputs = inputs;
  };
}
