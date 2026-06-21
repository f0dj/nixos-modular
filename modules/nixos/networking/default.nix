/**
 * @file: modules/nixos/networking/default.nix
 * @purpose: NixOS module for networking configuration (hostname, NetworkManager).
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.networking;
in {
  # Networking module
  #
  # This module configures network interfaces, hostname, and network management.

  options.my.networking = {
    enable = mkEnableOption "custom networking configuration";
  };

  imports = [
    ./firewall.nix
  ];

  config = mkIf cfg.enable {
    networking = {
      # System hostname (used for network identification)
      hostName = "nixos";
      
      # NetworkManager configuration
      networkmanager = {
        enable = true;            # Use NetworkManager for network configuration
        wifi.powersave = false;   # Disable WiFi power saving for better stability
      };
      
      # Disable IPv6 support (simplifies network configuration)
      enableIPv6 = false;
    };
  };
}
