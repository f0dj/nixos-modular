/**
 * @file: modules/nixos/services/default.nix
 * @purpose: NixOS module for miscellaneous system services.
 * @type: NixOS Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.services;
in {
  # System services module
  #
  # This module configures miscellaneous system services and utilities.

  options.my.services = {
    enable = mkEnableOption "miscellaneous system services";
  };

  imports = [
    ./fwupd.nix
  ];

  config = mkIf cfg.enable {
    # CUPS for printing (common Unix printing system)
    services.printing.enable = true;

    # ClamAV antivirus engine
    services.clamav = {
      daemon.enable = true; # Enable the ClamAV scanning daemon
      updater.enable = true; # Enable automatic virus signature updates
    };

    # File locating service (plocate - faster alternative to mlocate)
    services.locate = {
      enable = true; # Enable the locate database service
      package = pkgs.plocate; # Use plocate for faster searches
      interval = "hourly"; # Update the file database hourly
      
      # By default, NixOS prunes some paths (like /home or mount points).
      # Setting prunePaths to an empty list (or minimal set) ensures the whole drive is indexed.
      # We still exclude transient and virtual filesystems for performance and stability.
      prunePaths = [
        "/tmp"
        "/var/tmp"
        "/proc"
        "/sys"
        "/dev"
        "/run"
      ];
    };

    # Tracker for file searching and metadata extraction (GNOME)
    services.gnome.tinysparql.enable = true;
    services.gnome.localsearch.enable = true;

    # Enable fstrim for SSD maintenance (improves performance over time)
    services.fstrim.enable = true;
  };
}
