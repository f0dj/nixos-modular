/**
 * @file: modules/home/programs/btop.nix
 * @purpose: Home Manager module for configuring the btop resource monitor.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.programs;
in {
  # Btop resource monitor configuration
  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;  # Enable btop
      # settings = {}; # Use default settings
    };
  };
}
