/**
 * @file: modules/home/programs/default.nix
 * @purpose: Main Home Manager module for user program configurations.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.programs;
in {
  # Program configurations module
  #
  # This module configures individual user programs and applications.
  # Sub-configurations are imported from separate files in the same directory.

  options.my.programs = {
    enable = mkEnableOption "user program configurations";
  };

  imports = [
    ./btop.nix
    ./direnv.nix
    ./git.nix
    ./gnome.nix
    ./ssh.nix
    ./wine-bottles.nix
  ];

  config = mkIf cfg.enable {
    # Any general program settings would go here
  };
}
