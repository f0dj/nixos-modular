/**
 * @file: modules/home/programs/gnome.nix
 * @purpose: Home Manager module for configuring the GNOME desktop environment.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.programs; in
{
  config = mkIf cfg.enable {
    # This module configures the GNOME desktop environment for the user.

    # Install GNOME-related packages, including extensions, tweaks, and the terminal.
    home.packages = with pkgs; [
      gnomeExtensions.appindicator         # AppIndicator/KStatusNotifierItem support
      gnomeExtensions.windownavigator      # Keyboard-based window navigation
      gnomeExtensions.workspace-indicator  # Shows the current workspace
      gnomeExtensions.rclone-manager       # GUI for managing rclone remotes
      gnomeExtensions.hide-universal-access # Hides the Universal Access icon
      gnomeExtensions.mute-spotify-ads     # Mutes Spotify ads
      gnome-tweaks                         # Tool to customize GNOME settings
      gnome-terminal                       # The default GNOME terminal
    ];

    # Enable the GNOME Keyring service to store secrets and passwords.
    services.gnome-keyring.enable = true;

    # Configure system settings using dconf.
    dconf.settings = {
      # Set the desktop to prefer dark mode.
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      # Manage GNOME Shell extensions.
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # List of extensions to enable.
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
          "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          "hide-universal-access@akiirui.github.io"
          "rclone-manager@germanztz.com"
        ];

        # List of extensions to disable.
        disabled-extensions = [
          "spotify-ad-block@danigm.net"
        ];
      };
    };

    # Configure GTK settings.
    gtk = {
      enable = true;
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
    };

    # Configure Qt settings to integrate with the GTK theme.
    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };
  };
}
