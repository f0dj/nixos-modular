/**
 * @file: modules/nixos/security/default.nix
 * @purpose: NixOS module for security-related services (GPG, TPM2, etc.).
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.security;
in {
  # Security services module
  #
  # This module configures security-related services like GnuPG and polkit.

  options.my.security = {
    enable = mkEnableOption "security configuration";
  };

  imports = [
    ./sops.nix
  ];

  config = mkIf cfg.enable {
    # GnuPG (GPG) configuration
    programs.gnupg.agent = {
      enable = true;            # Enable the GPG agent for key management
      enableSSHSupport = true;  # Use GPG agent for SSH authentication
    };

    # Polkit for privilege management (required for some desktop operations)
    security.polkit.enable = true;

    # PC/SC daemon for smart card access
    services.pcscd.enable = true;

    # Enable TPM2 service and user space tools
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;  # Expose TPM2 via PKCS#11
      tctiEnvironment.enable = true; # Set TCTI env vars
    };

    # GNOME Keyring integration with PAM
    # Automatically unlocks the keyring on login via GDM
    security.pam.services.gdm.enableGnomeKeyring = true;

    # Fingerprint authentication service
    services.fprintd = {
      enable = true;
      # Use Touch-based fingerprint reader package
      package = pkgs.fprintd-tod;
      tod = {
        enable = true;
        # Driver for Goodix fingerprint readers
        driver = pkgs.libfprint-2-tod1-goodix;
      };
    };

    # Custom PAM configuration for fingerprint authentication with GDM
    # This configuration:
    # 1. Uses fingerprint authentication via fprintd
    # 2. Integrates with systemd to unlock the keyring using the stashed LUKS password
    # 3. Enables GNOME Keyring auto-unlock on successful fingerprint authentication
    security.pam.services.gdm-fingerprint.text = lib.mkForce ''
      auth       required                    pam_shells.so
      auth       requisite                   pam_nologin.so
      auth       requisite                   pam_faillock.so      preauth
      auth       required                    ${pkgs.fprintd-tod}/lib/security/pam_fprintd.so
      auth       required                    pam_env.so conffile=/etc/pam/environment readenv=0
      auth       optional                    ${pkgs.systemd}/lib/security/pam_systemd_loadkey.so
      auth       [success=ok default=1]      ${pkgs.gdm}/lib/security/pam_gdm.so
      auth       optional                    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so     auto_start

      account    include                     login
      password   required                    pam_deny.so
      session    include                     login
    '';
  };
}
