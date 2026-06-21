/**
 * @file: overlays/libreoffice/default.nix
 * @purpose: Pin 'libreoffice' to a fixed nixpkgs commit to avoid lengthy recompilation on updates.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin libreoffice to avoid rebuilds on nixpkgs-unstable channel updates
  libreoffice = (import inputs.nixpkgs-libreoffice {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).libreoffice;
}
