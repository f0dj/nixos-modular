/**
 * @file: modules/nixos/boot/default.nix
 * @purpose: System bootloader and early initrd configuration.
 * @type: NixOS Module
 * @namespace: my
 */

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.boot;
in {
  options.my.boot = {
    enable = mkEnableOption "custom boot configuration including systemd-boot and initrd enhancements";
  };

  config = mkIf cfg.enable {
    # Primary Bootloader Configuration
    # Using systemd-boot for simplicity and performance on modern UEFI systems.
    boot.loader.systemd-boot.enable = true;
    
    # Allow the OS to modify UEFI variables for managing boot entries.
    boot.loader.efi.canTouchEfiVariables = true;
    
    # Enable systemd in initrd (Early Boot)
    # This provides a more consistent environment during early boot and is required 
    # for certain advanced features such as LUKS password caching (via systemd-ask-password).
    #
    # Technical Rationale: systemd-initrd allows sharing credentials between the initrd 
    # and the system proper (e.g., unlocking the GNOME Keyring with the same disk password).
    boot.initrd.systemd.enable = true;
    boot.initrd.systemd.tpm2.enable = true;
    
    # TODO(hardware): Add support for specific kernel parameters based on hardware (e.g., amd_iommu=on).
  };
}
