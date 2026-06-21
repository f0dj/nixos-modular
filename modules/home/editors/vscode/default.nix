/**
 * @file: modules/home/editors/vscode/default.nix
 * @purpose: Home Manager module for configuring the VS Code editor.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.editors.vscode;
in {
  # VS Code configuration module
  #
  # This module configures the VS Code text editor, including extensions,
  # user settings, and keyboard shortcuts.

  options.my.editors.vscode = {
    enable = mkEnableOption "VS Code editor configuration";
  };

  config = mkIf cfg.enable {
    # VS Code configuration
    programs.vscode = {
      enable = true; # Enable VS Code
      package = pkgs.vscode; # Use standard VS Code package

      profiles.default = {
        # List of VS Code extensions to install
        extensions = with pkgs.vscode-extensions; [
          # Nix language support
          bbenoist.nix
          # Provides integration with Docker
          ms-azuretools.vscode-docker
          # Allows working with code over an SSH connection
          ms-vscode-remote.remote-ssh
          # A viewer for Excel and CSV files
          grapecity.gc-excelviewer
          # Code formatter
          esbenp.prettier-vscode
          # View git history and file history
          donjayamanne.githistory
          # Git supercharged
          eamodio.gitlens
          # Run code snippets or files for multiple languages
          formulahendry.code-runner
          # Custom file icons
          tal7aouy.icons
          # A tool to change the color of your VS Code workspace
          johnpapa.vscode-peacock
          # Improve your comments by annotating them with alerts, notes, etc.
          aaron-bond.better-comments
          # All-in-one markdown plugin
          yzhang.markdown-all-in-one
        ];

        # User settings for VS Code
        userSettings = {
          # Editor font configuration
          "editor.fontFamily" = "'FiraCode Nerd Font', monospace";
          "editor.fontSize" = 14;

          # Git and source control settings
          "git.enableSmartCommit" = true;
          "git.confirmSync" = false;

          # Miscellaneous UI settings
          "telemetry.enableTelemetry" = false;
          "workbench.colorTheme" = "Default Dark Modern";
        };
      };
    };
  };
}
