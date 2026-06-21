/**
 * @file: modules/home/programs/ssh.nix
 * @purpose: Home Manager module for configuring the SSH client.
 * @type: Module
 * @namespace: my
 */
{ config, lib, ... }:

with lib;
let cfg = config.my.programs; in
{
  config = mkIf cfg.enable {
    # This module configures the user's SSH client.
    programs.ssh = {
      enable = true;
      # We disable the default config to have full control over the settings.
      enableDefaultConfig = false;

      # Define custom `Host`/`Match` blocks for the SSH configuration.
      settings = {
        # The "*" block applies to all hosts.
        "*" = {
          # These options can be uncommented to enable support for legacy
          # ssh-rsa algorithms if needed for older servers.
          # HostKeyAlgorithms = "+ssh-rsa";
          # PubkeyAcceptedKeyTypes = "+ssh-rsa";

          # Forward the SSH agent to allow remote hosts to use local SSH keys.
          ForwardAgent = true;
          # Send locale environment variables to the remote host.
          SendEnv = [ "LANG" "LC_*" ];
        };

        # Example block for a specific IP range.
        # "192.168.*.*" = {
        #   HostKeyAlgorithms = "+ssh-rsa";
        # };

        # Example block for configuring a connection to a `gsconnect` device.
        # "gsconnect" = {
        #   Port = 2222;
        #   IdentityFile = "~/.ssh/gsconnect_rsa";
        # };
      };
    };
  };
}
