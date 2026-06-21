/**
 * @file: modules/nixos/fonts/default.nix
 * @purpose: NixOS module for installing a curated collection of system fonts.
 * @type: Module
 * @namespace: my
 */
{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.my.fonts;
in {
  # System fonts module
  #
  # This module installs a curated collection of fonts for the system.
  # Fonts are available to all users and applications.

  options.my.fonts = {
    enable = lib.mkEnableOption "system-wide fonts";
  };

  config = lib.mkIf cfg.enable {
    fonts.packages = with pkgs; [
      # --------------------------------------------------------------------------
      # Monospaced programming fonts
      # --------------------------------------------------------------------------
      hack-font # Hack monospace font (based on DejaVu Sans Mono)
      fira-code # Fira Code monospace font with programming ligatures
      fira-code-symbols # Additional symbols for Fira Code

      # --------------------------------------------------------------------------
      # Sans-serif fonts
      # --------------------------------------------------------------------------
      roboto # Roboto sans-serif font (Google's system font)

      # --------------------------------------------------------------------------
      # Icon fonts
      # --------------------------------------------------------------------------
      font-awesome # Font Awesome icon set

      # --------------------------------------------------------------------------
      # Unicode and international fonts
      # --------------------------------------------------------------------------
      noto-fonts # Google Noto fonts (broad Unicode coverage)
      noto-fonts-cjk-sans # Noto Sans CJK for Chinese, Japanese, Korean text
      noto-fonts-color-emoji # Color emoji support

      # --------------------------------------------------------------------------
      # Nerd Fonts (patched fonts with icons)
      # --------------------------------------------------------------------------
      nerd-fonts.fira-code # Fira Code with Nerd Font icons
      nerd-fonts.hack # Hack with Nerd Font icons
      nerd-fonts.symbols-only # Standalone Nerd Font symbols

      # --------------------------------------------------------------------------
      # Miscellaneous fonts
      # --------------------------------------------------------------------------
      freefont_ttf # GNU FreeFont family (provides FreeSans used by Doom Emacs)
    ];
  };
}
