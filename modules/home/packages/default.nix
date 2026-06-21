/**
 * @file: modules/home/packages/default.nix
 * @purpose: Home Manager module for managing user-specific packages.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.packages;
in {
  # Home Manager packages module
  #
  # This module installs user-specific packages via Home Manager.

  options.my.packages = {
    enable = mkEnableOption "Home Manager packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      home-manager       # Home Manager command-line tool
      proton-vpn         # ProtonVPN graphical client
      deluge-gtk         # GTK-based BitTorrent client
      rclone             # Command-line cloud storage synchronization
      yt-dlp             # YouTube and video site downloader
      tor-browser        # Privacy-focused web browser using Tor network
      element-desktop    # Matrix chat client with end-to-end encryption
      wasabiwallet       # Bitcoin wallet with privacy features
      teams-for-linux    # Unofficial Microsoft Teams desktop client
      discord            # Gaming and community chat application
      gh                 # GitHub command-line interface
      obsidian           # Markdown-based note-taking application
      pika-backup        # Simple backup tool using BorgBackup
      calibre            # E-book library management and conversion
      proton-pass        # Proton's password manager with end-to-end encryption
      picard             # MusicBrainz tagger for audio files
      czkawka            # Duplicate file finder and cleanup tool
      kdePackages.kleopatra # Certificate Manager and Unified Crypto GUI
      aria2              # Lightweight multi-protocol download utility
      glow               # Terminal-based Markdown renderer
      p7zip              # 7-Zip file archiver with high compression ratio
      tree               # Directory listing in tree format
      broot              # Interactive directory navigation and file manager
      sshfs              # Mount remote filesystems via SSH
      baobab             # GNOME disk usage analyzer
      fastfetch          # System information display tool
      cryptomator        # Client-side encryption for cloud storage
      vlc                # Versatile media player
      scid-vs-pc         # Chess database and analysis application
      libreoffice        # Office suite
      spotify            # Music streaming service client
      digikam            # Professional photo management application
      gimp               # GNU Image Manipulation Program
      gnome-sound-recorder # Simple audio recording utility
      gthumb             # Image viewer and organizer
      pcloud             # pCloud cloud storage desktop client
    ];
  };
}
