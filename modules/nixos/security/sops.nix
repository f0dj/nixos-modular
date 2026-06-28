/**
 * @file: modules/nixos/security/sops.nix
 * @purpose: NixOS module for configuring sops-nix for secret management.
 * @type: NixOS Module
 * @namespace: my
 */
{ config, lib, ... }:

with lib;
let
  cfg = config.my.security;
in {
  # SOPS secret management module
  #
  # This module configures sops-nix for declarative secret management.

  config = mkIf cfg.enable {
    # SOPS default configuration
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;  # Path to encrypted secrets
      defaultSopsFormat = "yaml";                       # Secrets are stored in YAML format
      
      # Enable validation of encrypted secrets files
      validateSopsFiles = true;

      # Age encryption configuration
      age = {
        generateKey = true;           # Automatically generate age key if missing
        keyFile = "/var/lib/sops-nix/key.txt";  # Path to age key file
        sshKeyPaths = [];             # Don't use SSH keys for decryption
      };

      # Individual secret definitions
      secrets.syncthing_password = {
        owner = config.my.personal.username;  # User who owns the decrypted secret file
      };

      secrets.deepseek_api_key = {
        owner = config.my.personal.username;
      };
    };
  };
}
