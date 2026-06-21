/**
 * @file: modules/home/programs/git.nix
 * @purpose: Home Manager module for configuring Git version control.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, osConfig ? {}, ... }:

with lib;
let
  cfg = config.my.programs;
in {
  # Git version control configuration
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;                 # Enable Git
      
      settings = {
        user = {
          name = osConfig.my.personal.name or "NixOS User";             # Git user name
          email = osConfig.my.personal.email or "user@example.com";      # Git user email
        };
        
        # Additional Git configuration settings
        init.defaultBranch = "main"; # Set default branch name
        pull.rebase = true;          # Rebase on pull by default
        core.editor = "nvim";        # Use Neovim as default editor
      };
    };
  };
}
