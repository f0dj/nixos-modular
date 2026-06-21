/**
 * @file: modules/home/scripts/default.nix
 * @purpose: Home Manager module for installing custom shell scripts.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.scripts;
in {
  # Custom shell scripts module
  #
  # This module installs custom shell scripts for the user.

  options.my.scripts = {
    enable = mkEnableOption "custom shell scripts";
  };

  config = mkIf cfg.enable {
    # Install custom scripts
    home.packages = [
      (pkgs.writeShellScriptBin "toggle_touchpad" ''
        # Get the current status of the touchpad.
        current_status=$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)

        # Toggle the state. If it's currently enabled, disable it. Otherwise, enable it.
        if [ "$current_status" = "'enabled'" ]; then
          gsettings set org.gnome.desktop.peripherals.touchpad send-events 'disabled'
          notify-send "Touchpad Disabled"
        else
          gsettings set org.gnome.desktop.peripherals.touchpad send-events 'enabled'
          notify-send "Touchpad Enabled"
        fi
      '')
    ];
  };
}
