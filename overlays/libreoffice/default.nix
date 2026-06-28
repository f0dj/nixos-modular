/**
 * @file: overlays/libreoffice/default.nix
 * @purpose: Pin 'libreoffice' to a fixed nixpkgs commit to avoid lengthy recompilation on updates.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin libreoffice to avoid rebuilds on nixpkgs-unstable channel updates
  #
  # PIN(pinned 2026-05-07): Avoids lengthy recompilation.
  # Remove when ready to accept the rebuild cost on next flake update.
  libreoffice = (import inputs.nixpkgs-libreoffice {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).libreoffice;
}
