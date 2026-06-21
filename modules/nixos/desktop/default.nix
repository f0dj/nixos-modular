/**
 * @file: modules/nixos/desktop/default.nix
 * @purpose: NixOS module for configuring the GNOME desktop environment.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.desktop;
in {
  # Desktop environment module
  #
  # This module configures the GNOME desktop environment, display manager,
  # and related graphical settings.

  options.my.desktop = {
    enable = mkEnableOption "GNOME desktop environment";
  };

  config = mkIf cfg.enable {
    # Enable X11 window system (required for GNOME)
    services.xserver.enable = true;

    # GNOME desktop environment and GDM display manager
    services = {
      desktopManager.gnome.enable = true;  # GNOME desktop
      displayManager.gdm.enable = true;    # GNOME Display Manager
    };

    # Set GNOME as the default session for the display manager
    services.displayManager.defaultSession = "gnome";

    # Exclude unnecessary GNOME applications to maintain a minimal installation
    environment.gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
      snapshot
      cheese
      gnome-calendar
      gnome-maps
      gnome-weather
      gnome-contacts
      gnome-music
      showtime
      epiphany
      geary
      totem
      simple-scan
      decibels
      loupe
    ];

    # Keyboard layout configuration for X11
    services.xserver.xkb = {
      layout = "br";    # Brazilian Portuguese layout
      variant = "";     # No variant (default)
    };

    # Keyboard layout for virtual console (TTY)
    console.keyMap = "br-abnt2";  # Brazilian Portuguese ABNT2 layout

    # Graphics driver configuration
    services.xserver.videoDrivers = [ "nvidia" ];  # NVIDIA proprietary driver
  };
}
