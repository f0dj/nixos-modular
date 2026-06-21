/**
 * @file: homes/x86_64-linux/nixos@nixos/default.nix
 * @purpose: Home Manager user configuration for 'nixos'.
 * @type: Home Configuration
 * @namespace: my
 */

{ config, pkgs, lib, inputs, osConfig ? {}, ... }:

{
  # Core user environment configuration
  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    
    # State version used for backward compatibility with older Home Manager versions.
    # Changing this may trigger migration scripts or breaking changes in HM modules.
    stateVersion = "26.05";
  };

  # Custom configuration modules (Namespaced under 'my')
  # These modules are defined in the project's 'modules/home/' directory.
  my = {
    # System core tools and utilities
    packages.enable = true;
    session.enable = true;
    shell.enable = true;
    files.enable = true;
    scripts.enable = true;
    programs.enable = true;
    
    # Editor configurations
    editors = {
      vscode.enable = true;
      doom-emacs.enable = true;
      nixvim = {
        enable = true;
        plugins = {
          avante.enable = true;
          blink.enable = true;
          bufferline.enable = true;
          catppuccin.enable = true;
          conform.enable = true;
          dap.enable = true;
          fzf-lua.enable = true;
          fugitive.enable = true;
          git = {
            enable = true;
            diffview.enable = true;
            gitlinker.enable = true;
            gitsigns.enable = true;
          };
          indent.enable = true;
          lint.enable = true;
          lsp = {
            enable = true;
            lspsaga.enable = true;
            lsp-lines.enable = false; # Original was false in lsp.nix
          };
          orgmode.enable = true;
          lualine.enable = true;
          luasnip.enable = true;
          lz-n.enable = true;
          mini.enable = true;
          neotest.enable = true;
          noice.enable = true;
          schemastore.enable = true;
          snacks = {
            enable = true;
            git.enable = true;
            indent.enable = true;
            lazygit.enable = true;
            notifier.enable = true;
            picker.enable = false; # Original snacks/default.nix had picker commented out
          };
          supermaven.enable = true;
          treesitter = {
            enable = true;
            textobjects.enable = true;
          };
          trouble.enable = true;
          ufo.enable = true;
          utils = {
            enable = true;
            codecompanion.enable = true;
            comment-box.enable = true;
            comment.enable = true;
            oil.enable = true;
            web-devicons.enable = true;
            which-key.enable = true;
          };
        };
      };
    };
  };

  # Enable Home Manager to manage its own installation.
  programs.home-manager.enable = true;
  
  # TODO(dotfiles): Add specific file symlinks or template overrides for dotfiles.
  # TODO(multi-user): Abstract common home configuration to a shared module if adding more users.
}
