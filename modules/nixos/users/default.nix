/**
 * @file: modules/nixos/users/default.nix
 * @purpose: NixOS module for configuring system user accounts and permissions.
 * @type: Module
 * @namespace: my
 */
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.users;
  personal = config.my.personal;
in {
  imports = [
    (if builtins.pathExists ./personal.nix then ./personal.nix else ./personal.nix.example)
  ];

  # User accounts module
  #
  # This module configures system users, their permissions, and default settings.

  options.my.personal = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = "The primary user's username.";
    };
    name = lib.mkOption {
      type = lib.types.str;
      default = "NixOS User";
      description = "The primary user's full name.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "user@example.com";
      description = "The primary user's email address.";
    };
    timeZone = lib.mkOption {
      type = lib.types.str;
      default = "UTC";
      description = "The system-wide timezone.";
    };
    defaultLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The system-wide default locale.";
    };
    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The system-wide extra locale setting.";
    };
    inputMethod = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "The default editor input method.";
    };
    orgDirectory = lib.mkOption {
      type = lib.types.str;
      default = "~/Org";
      description = "The default directory for Org-mode files.";
    };
  };

  options.my.users = {
    enable = lib.mkEnableOption "system-wide user accounts";
  };

  config = lib.mkIf cfg.enable {
    # Primary user account configuration
    users.users.${personal.username} = {
      isNormalUser = true; # This is a regular user (not a system account)
      description = personal.name; # Display name for the user

      # Group memberships grant specific permissions to the user
      extraGroups = [
        "networkmanager" # Manage network connections (NetworkManager)
        "wheel" # Administrative privileges (sudo access)
        "plocate" # Use the locate command for file searching
        "docker" # Docker container management (when Docker is enabled)
      ];

      # User-specific system packages (installed globally but only for this user)
      packages = with pkgs; [
        # thunderbird        # Email client (commented out - not currently used)
      ];
    };

    # Set the default shell for all users on the system
    # This affects new users; existing users keep their current shell
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;
  };
}
