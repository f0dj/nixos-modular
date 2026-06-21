/**
 * @file: overlays/emacs/default.nix
 * @purpose: Apply the pinned Emacs overlay from the flake inputs.
 * @type: Overlay
 * @namespace: my
 */

{ inputs, ... }:

final: prev:
let
  # The emacs-overlay can sometimes depend on specific lib functions.
  # We satisfy this by injecting the lib from the nixpkgs input.
  prevWithLib = prev // { 
    lib = prev.lib // inputs.nixpkgs.lib; 
  };
in
inputs.emacs-overlay.overlays.default final prevWithLib
