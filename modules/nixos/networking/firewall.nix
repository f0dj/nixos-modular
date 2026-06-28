/**
 * @file: modules/nixos/networking/firewall.nix
 * @purpose: NixOS module for configuring firewall rules and allowed ports.
 * @type: NixOS Module
 * @namespace: my
 */
{ config, lib, ... }:

with lib;
let
  cfg = config.my.networking;
in {
  # Firewall configuration module
  #
  # This module configures firewall rules, allowed ports, and protocols.

  config = mkIf cfg.enable {
    networking.firewall = {
      enable = true;          # Enable the built-in NixOS firewall
      
      # Trusted network interfaces (firewall is disabled on these interfaces)
      trustedInterfaces = [
        "virbr0"  # Default bridge interface created by libvirtd for virtual machines
      ];

      # Allowed TCP ports (open to the network)
      allowedTCPPorts = [
        22                    # SSH (for remote access)
      ];
      
      # Allowed UDP ports (open to the network)
      allowedUDPPorts = [
        # 53                  # DNS (commented out)
      ];
      
      # Whether to log packets that are rejected (dropped) by the firewall
      # Useful for debugging network connection issues
      # logRejectedPackets = true;
    };
  };
}
