/**
 * @file: overlays/digikam/default.nix
 * @purpose: Pin 'digikam' to a fixed nixpkgs commit to avoid lengthy recompilation on updates.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Pin digikam to avoid rebuilds on nixpkgs-unstable channel updates
  digikam = (import inputs.nixpkgs-digikam {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  }).digikam;
}
