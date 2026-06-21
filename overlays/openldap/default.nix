/**
 * @file: overlays/openldap/default.nix
 * @purpose: Pin 'openldap' to the stable channel to resolve build failures in unstable.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin openldap to stable to avoid build/test regressions in unstable
  openldap = (import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).openldap;
}
