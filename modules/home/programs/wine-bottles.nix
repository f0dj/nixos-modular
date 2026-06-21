/**
 * @file: modules/home/programs/wine-bottles.nix
 * @purpose: Home Manager module for configuring Wine and Bottles.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let cfg = config.my.programs; in
{
  config = mkIf cfg.enable {
    # This module installs packages for running Windows applications using Wine and Bottles.
    home.packages = with pkgs; [
      # Bottles is a graphical manager for Wine prefixes (environments).
      bottles
      # Winetricks is a helper script to download and install various redistributable
      # runtime libraries needed to run some programs in Wine.
      winetricks
      # A full-featured Wine build with Wayland support.
      wineWow64Packages.waylandFull
      # Mono is an open-source implementation of Microsoft's .NET Framework.
      mono
    ];
  };
}
