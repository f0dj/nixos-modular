/**
 * @file: modules/home/shell/default.nix
 * @purpose: Home Manager module for configuring the Zsh shell.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.shell;
in {
  # Zsh shell configuration module
  #
  # This module configures the Zsh shell, including interactive features,
  # plugins, and custom shell functions.

  options.my.shell = {
    enable = mkEnableOption "Zsh shell configuration";
  };

  config = mkIf cfg.enable {
    # Zsh configuration
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      dotDir = "${config.home.homeDirectory}/.config/zsh";

      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      # Shell aliases for common commands
      shellAliases = {
        myaliases = "myaliases";
        ll = "ls -la --group-directories-first --color";
        l = "ls -l --group-directories-first --color";
        ls = "ls --group-directories-first --color";
        # Navigation aliases
        cd = "cd";
        ".." = "cd ..";
        cl = "clear";
        # Nix-related aliases
        nfu = "nix flake update";
        nrswitch = "sudo nixos-rebuild switch --flake path:.#nixos --max-jobs 1 --show-trace";
        nrtest = "sudo nixos-rebuild test --flake path:.#nixos --max-jobs 1 --show-trace";
        hmswitch = "home-manager switch --flake path:.";
        nixdiff = "nixdiff-latest";
        nrepl = "nix repl --file '<nixpkgs>'";
        
        # Comprehensive Cleanup
        # Deletes HM, User, and System generations older than 7 days and optimizes the store.
        nixstorecl = "sudo nix-collect-garbage --delete-older-than 7d && sudo nix store optimise && home-manager expire-generations '-7 days' && nix-collect-garbage --delete-older-than 7d";
        # Deletes ALL but the current HM, User, and System generations and optimizes the store.
        nixstorecl_active = "sudo nix-collect-garbage -d && sudo nix store optimise && home-manager expire-generations '0 days' && nix-collect-garbage -d";

        # Targeted Cleanup
        hm-clean = "home-manager expire-generations '-7 days'";
        # Deletes ALL but the current Home Manager generation.
        hm-clean_active = "home-manager expire-generations '0 days'";


        # System maintenance aliases
        # Cleans up system generations older than 7 days and updates the bootloader menu.
        grubclean = "sudo nix-env --delete-generations 7d --profile /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
        # Deletes ALL but the current system generation and updates the bootloader menu.
        grubclean_active = "sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";
        udb = "sudo updatedb";
        # Security aliases
        csc = "clamscan --recursive --infected --max-filesize=4000M --max-scansize=4000M";
        # File size
        fsize = "du -shc";
      };

      # Configure Zsh history settings.
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

      # Extra lines to add to the top of .zshrc
      profileExtra = ''
        # Allow comments to be used in interactive shell sessions.
        setopt interactivecomments
      '';

      # Custom initialization code for interactive shells
      initContent = ''
        # Customize the git prompt indicators for Powerlevel10k.
        ZSH_THEME_GIT_PROMPT_AHEAD="↑%{%F{yellow}%}"
        ZSH_THEME_GIT_PROMPT_BEHIND="↓%{%F{yellow}%}"

        # Source external shell functions.
        source ${./zsh_conf_functions.sh}

        # Set DeepSeek API key from sops secret if available
        if [ -f /run/secrets/deepseek_api_key ]; then
          export DEEPSEEK_API_KEY="$(cat /run/secrets/deepseek_api_key)"
        fi

        # Enable the Powerlevel10k theme and its instant prompt feature.
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

        # To customize the prompt, run `p10k configure` and place the generated
        # ~/.p10k.zsh file in this directory, then uncomment the following line:
        # [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      '';
    };
  };
}
