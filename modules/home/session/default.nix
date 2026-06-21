/**
 * @file: modules/home/session/default.nix
 * @purpose: Home Manager module for configuring session environment variables.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.session;
in {
  # Session environment variables module
  #
  # This module configures environment variables for the user's session.

  options.my.session = {
    enable = mkEnableOption "session environment variables";
  };

  config = mkIf cfg.enable {
    # System-wide session environment variables
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "vivaldi";
      # Workaround for Nautilus rendering issues with NVIDIA drivers
      GSK_RENDERER = "gl";
    };

    # Additional directories to add to PATH
    home.sessionPath = [
      "$HOME/.local/bin"
    ];
  };
}
