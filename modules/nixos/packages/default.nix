/**
 * @file: modules/nixos/packages/default.nix
 * @purpose: System-wide packages configuration for the NixOS system.
 * @type: Module
 * @namespace: my
 */
{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.packages;
in {
  # System packages module
  #
  # This module installs packages system-wide, making them available to all users.
  # Use this for essential utilities and tools that should be globally accessible.

  options.my.packages = {
    enable = mkEnableOption "system-wide packages";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # --------------------------------------------------------------------------
      # Basic & System Utilities
      # --------------------------------------------------------------------------
      wget # Command-line network downloader
      curl # Tool for transferring data with URL syntax
      git # Distributed version control system
      gettext # Internationalization and localization tools

      # Hardware & Diagnostic
      pciutils # Utilities for inspecting and managing PCI devices (lspci)
      usbutils # Utilities for inspecting and managing USB devices (lsusb)
      lshw # Detailed hardware information listing tool
      mesa-demos # Graphics information (glxinfo)
      dmidecode # BIOS/Hardware information

      # System Monitoring & Management
      btop # Resource monitor that shows usage and stats
      iotop # I/O monitor
      lsof # List open files

      # Modern CLI Tools
      ripgrep # Fast line-oriented search tool (rg)
      fd # Simple, fast and user-friendly alternative to 'find'
      eza # A modern replacement for 'ls'
      dust # A more intuitive version of 'du' in rust
      ncdu # NCurses disk usage analyzer

      # File Management & Archiving
      unzip             # Extraction utility for archives compressed in .zip format
      zip               # Package and compress (archive) files
      rsync             # Fast incremental file transfer tool
      file              # Determine file type
      tree              # Directory listing in tree format
      which             # Locates a program in the user's path
      
      # Nix Specific
      nvd               # Nix package version diff tool (compare system generations)
      
      # Security & Networking
      wireguard-tools   # WireGuard VPN configuration and management tools
      age               # Modern, simple encryption tool (used with sops-nix)
      sops              # Secret management tool (SOPS)
      
      # Desktop & Applications
      gnome-tweaks      # GNOME desktop customization utility
      (vivaldi.override { proprietaryCodecs = true; }) # Vivaldi web browser with proprietary media codecs
    ];
  };
}
