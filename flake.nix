/**
 * @file: flake.nix
 * @purpose: Entry point for the NixOS configuration using Snowfall Lib.
 * @type: System configuration
 * @namespace: my
 */

{
  description = "A modular and functional NixOS configuration for my setup.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/cd53e7ae1f05b8030245e341ac33fb902ec7d0b7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snacks-nvim = {
      url = "github:folke/snacks.nvim";
      flake = false;
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay/f85952894cfbc4f6dae2f12e28cefc6bdcbb6ece";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # TODO(architecture): Consider migrating from Snowfall Lib to manual
    # flake outputs. Single-host/single-user config saves ~50 lines of
    # boilerplate at the cost of a hard dependency and user workarounds.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-libreoffice = {
      url = "github:NixOS/nixpkgs/1c3fe55ad329cbcb28471bb30f05c9827f724c76";
    };

    nixpkgs-digikam = {
      url = "github:NixOS/nixpkgs/a799d3e3886da994fa307f817a6bc705ae538eeb";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      snowfall = {
        namespace = "my";
        meta = {
          name = "nixos-config";
          title = "NixOS Configuration";
        };
      };

      channels-config = {
        allowUnfree = true;
      };

      systems.modules.nixos = [
        inputs.sops-nix.nixosModules.sops
        inputs.home-manager.nixosModules.home-manager # Enable HM at system level
      ];

      homes.modules = [
        inputs.sops-nix.homeManagerModules.sops
      ];
    };
}
