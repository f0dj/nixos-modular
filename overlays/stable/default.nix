/**
 * @file: overlays/stable/default.nix
 * @purpose: Provide 'pkgs.stable' and pin 'teams-for-linux' to the stable channel.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev: {
  # Access stable packages via pkgs.stable
  stable = import inputs.nixpkgs-stable {
    system = final.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

  # Pin teams-for-linux to stable as requested
  teams-for-linux = final.stable.teams-for-linux;
}
