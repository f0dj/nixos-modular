/**
 * @file: systems/x86_64-linux/nixos/default.nix
 * @purpose: Core NixOS system configuration for the 'nixos' host.
 * @type: System Configuration
 * @namespace: my
 */

{ pkgs, lib, inputs, config, ... }:

{
  # Core System Imports
  imports = [
    (if builtins.pathExists ./hardware-configuration.nix then ./hardware-configuration.nix else ./hardware-configuration.nix.example)
  ];

  # Machine-specific environment and localization
  time.timeZone = config.my.personal.timeZone;
  i18n.defaultLocale = config.my.personal.defaultLocale;

  # Locale settings for specific categories
  i18n.extraLocaleSettings = lib.genAttrs [
    "LC_ADDRESS"
    "LC_IDENTIFICATION"
    "LC_MEASUREMENT"
    "LC_MONETARY"
    "LC_NAME"
    "LC_NUMERIC"
    "LC_PAPER"
    "LC_TELEPHONE"
    "LC_TIME"
  ] (_: config.my.personal.extraLocale);

  # Use latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable Intel PSR (Panel Self Refresh) to prevent flickering on hybrid systems
  boot.kernelParams = [ "i915.enable_psr=0" ];

  # Enable namespaced modules
  my = {
    boot.enable = true;
    desktop.enable = true;
    fonts.enable = true;
    hardware = {
      graphics.enable = true;
      audio.enable = true;
      bluetooth.enable = true;
    };
    networking.enable = true;
    packages.enable = true;
    programs = {
      enable = true;
      docker.enable = true;
      syncthing.enable = true;
      virtualization.enable = true;
      firefox.enable = true;
      steam.enable = true;
      vim.enable = true;
    };
    security.enable = true;
    services.enable = true;
    users.enable = true;
  };

  # Networking Configuration
  networking.hostName = "nixos";

  # Home Manager configuration
  # These settings ensure that HM packages are installed into the user profile
  # and that global nixpkgs settings are respected. Snowfall Lib automatically
  # discovers and applies the home configuration for the primary user.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  # Nix Package Manager Configuration
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      trusted-users = [ "root" config.my.personal.username ];
      allowed-users = [ config.my.personal.username ];
      download-buffer-size = 256 * 1024 * 1024;
    };
    
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # System-wide state version
  system.stateVersion = "25.11";

  # Snowfall Lib automatically discovers users from the homes/ directory and
  # creates system users (create=true) with admin privileges (admin=true) and
  # Home Manager integration (home.enable=true) by default. When a custom user
  # (e.g., 'your-username') is active via personal.nix, we disable all three for the
  # template 'nixos' user to avoid:
  #   1. Creating an unused 'nixos' system user on the machine
  #   2. Granting unnecessary admin (wheel) membership
  #   3. HM activation failures (nixos not in nix.settings.allowed-users)
  snowfallorg.users.nixos = {
    create = config.my.personal.username == "nixos";
    admin = config.my.personal.username == "nixos";
    home.enable = config.my.personal.username == "nixos";
  };
}
