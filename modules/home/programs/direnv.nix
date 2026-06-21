/**
 * @file: modules/home/programs/direnv.nix
 * @purpose: Home Manager module for configuring direnv and nix-direnv.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.programs; in
{
  config = mkIf cfg.enable {
    # Direnv configuration
    #
    # This module configures direnv, an environment switcher for the shell.
    # It also enables nix-direnv for better integration with Nix.

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
