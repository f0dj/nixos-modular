/**
 * @file: modules/home/editors/doom-emacs/default.nix
 * @purpose: Comprehensive configuration for Doom Emacs as a Home Manager module.
 * @type: Module
 * @namespace: my
 */

{ config, lib, pkgs, osConfig ? {}, ... }:

with lib;
let
  cfg = config.my.editors.doom-emacs;
in {
  options.my.editors.doom-emacs = {
    enable = mkEnableOption "Doom Emacs editor configuration";
    
    package = mkOption {
      type = types.package;
      default = pkgs.emacs-git;
      description = "The Emacs package to use (defaults to pinned emacs-git from overlay).";
    };
  };

  config = mkIf cfg.enable {
    # Doom Emacs main program configuration
    programs.emacs = {
      enable = true;
      package = cfg.package;
      
      extraPackages = epkgs: [
        epkgs.vterm
        epkgs.treesit-grammars.with-all-grammars
      ];
    };

    # System-level dependencies for Doom Emacs and its modules
    home.packages = with pkgs; [
      # Core Dependencies
      git
      ripgrep
      fd
      findutils
      gnuplot
      sqlite      # Required for org-roam and other modules
      imagemagick # Required for image manipulation in org-mode
      
      # Build Tools (for vterm, native-comp, etc.)
      gnumake
      cmake
      libtool
      gcc
      
      # Spell Checking
      aspell
      aspellDicts.en

      # Shell & Formatting
      shellcheck
      shfmt
      
      # Nix Support
      nixfmt
      nixd
      
      # Language Servers & Tooling
      ruff
      pyright
      bash-language-server
      julia-bin
      marksman
      vscode-langservers-extracted
      texlab

      # Fonts for UI & Icons
      emacs-all-the-icons-fonts
      noto-fonts-color-emoji
      nerd-fonts.hack
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
    ];

    # Symlink config files to ~/.config/doom
    # NOTE: DOOMDIR points here, while EMACSDIR points to the doomemacs repo.
    xdg.configFile."doom" = {
      source = ./config-files;
      recursive = true;
    };

    # Generate user details for Doom Emacs dynamically
    xdg.configFile."doom/user-details.el".text = ''
      (setq user-full-name "${osConfig.my.personal.name or "nixos"}"
            user-mail-address "${osConfig.my.personal.email or "user@example.com"}")
      (setq default-input-method "${osConfig.my.personal.inputMethod or "us"}")
      (setq org-directory "${osConfig.my.personal.orgDirectory or "~/Org"}"
            org-agenda-files '("${osConfig.my.personal.orgDirectory or "~/Org"}/agenda.org")
            org-journal-dir "${osConfig.my.personal.orgDirectory or "~/Org"}/journal/")
    '';

    # PATH management for Doom Emacs scripts and binaries
    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/.config/emacs/bin"
    ];
    
    # Session environment variables for proper Doom initialization
    home.sessionVariables = {
      DOOMDIR = "${config.xdg.configHome}/doom";
      EMACSDIR = "${config.xdg.configHome}/emacs";
    };
    
    # TODO(config): Consider adding an activation script to run 'doom sync' 
    # automatically, although this can be slow and brittle during builds.
  };
}
