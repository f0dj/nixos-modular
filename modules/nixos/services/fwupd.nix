/**
 * @file: modules/nixos/services/fwupd.nix
 * @purpose: NixOS module for configuring the fwupd firmware update service.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:

with lib;
let
  cfg = config.my.services;
in {
  # Firmware Update Service module
  #
  # This module configures fwupd for managing device firmware updates.

  config = mkIf cfg.enable {
    # Firmware Update Daemon
    # Allows updating BIOS, SSD, and other peripheral firmware from NixOS
    services.fwupd.enable = true;
  };
}
