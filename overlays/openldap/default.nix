/**
 * @file: overlays/openldap/default.nix
 * @purpose: Pin 'openldap' to the stable channel to resolve build failures in unstable.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin openldap to stable to avoid build/test regressions in unstable
  #
  # PIN(pinned 2026-04-25): Bypasses test017-syncreplication-refresh
  # failure in unstable. Remove when upstream fixes the test.
  openldap = (import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).openldap;
}
