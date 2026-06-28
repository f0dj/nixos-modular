/**
 * @file: overlays/stable/default.nix
 * @purpose: Provide 'pkgs.stable' and pin 'teams-for-linux' to the stable channel.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Access stable packages via pkgs.stable
  #
  # PIN(pinned 2026-04-25): Provides nixos-25.11 channel for packages
  # that fail to build in unstable. Re-evaluate when nixos-25.11 reaches
  # EOL (expected 2026-11) or when unstable fixes the individual failures.
  stable = import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # Pin teams-for-linux to stable as requested
  teams-for-linux = final.stable.teams-for-linux;
}
