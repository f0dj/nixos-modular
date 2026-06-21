/**
 * @file: overlays/scid-vs-pc/default.nix
 * @purpose: Pin 'scid-vs-pc' to the stable channel to resolve build failures in unstable.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin scid-vs-pc to stable to avoid build regressions in unstable
  scid-vs-pc = (import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).scid-vs-pc;
}
