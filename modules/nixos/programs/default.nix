/**
 * @file: modules/nixos/programs/default.nix
 * @purpose: System-wide programs configuration (Docker, Syncthing, Virtualization, Browsers, Gaming).
 * @type: NixOS Module
 * @namespace: my
 */

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.programs;
in {
  options.my.programs = {
    enable = mkEnableOption "system-wide programs";
    docker.enable = mkEnableOption "Docker container virtualization";
    syncthing.enable = mkEnableOption "Syncthing file synchronization";
    virtualization.enable = mkEnableOption "Libvirt/KVM virtualization";
    firefox.enable = mkEnableOption "Firefox web browser";
    steam.enable = mkEnableOption "Steam gaming platform";
    vim.enable = mkEnableOption "Vim text editor (system-wide)";
  };

  config = mkMerge [
    (mkIf cfg.enable {
      # Placeholder for global settings
    })

    (mkIf cfg.firefox.enable {
      programs.firefox.enable = true;
    })

    (mkIf cfg.vim.enable {
      programs.vim = {
        enable = true;
        package = pkgs.vim;
        defaultEditor = true;
      };
    })

    (mkIf cfg.steam.enable {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
      };
    })

    (mkIf cfg.docker.enable {
      virtualisation.docker = {
        enable = true;
        rootless = {
          enable = true;
          setSocketVariable = true;
        };
      };
      environment.systemPackages = [ pkgs.docker-compose ];
    })

    (mkIf cfg.syncthing.enable {
      services.syncthing = {
        enable = true;
        user = config.my.personal.username;
        group = "users";
        dataDir = "/home/${config.my.personal.username}/Syncthing";
        configDir = "/home/${config.my.personal.username}/.config/syncthing";
        openDefaultPorts = true;
        guiAddress = "0.0.0.0:8384";
        guiPasswordFile = if config ? sops && config.sops.secrets ? syncthing_password then config.sops.secrets.syncthing_password.path else null;
        overrideDevices = true;
        overrideFolders = true;
      };
    })

    (mkIf cfg.virtualization.enable {
      virtualisation.libvirtd.enable = true;
      
      systemd.services.virt-secret-init-encryption = {
        description = "Initialize libvirt secrets encryption key";
        after = ["local-fs.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            ""
            "${pkgs.bash}/bin/sh -c 'umask 0077 && (${pkgs.coreutils}/bin/dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
          ];
        };
      };

      # Ensure the default network is always started on boot.
      # This fixes "network 'default' is not active" errors in virt-manager.
      systemd.services.libvirtd-default-network = {
        description = "Ensure libvirt default network is started";
        after = ["libvirtd.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/sh -c '${pkgs.libvirt}/bin/virsh net-start default || true'";
          RemainAfterExit = true;
        };
      };

      programs.virt-manager = {
        enable = true;
        package = pkgs.stable.virt-manager;
      };

      users.users.${config.my.personal.username}.extraGroups = ["libvirtd"];

      environment.systemPackages = with pkgs; [
        qemu_kvm
        libvirt
        virt-viewer
        dnsmasq
        ebtables
        iptables
        bridge-utils
        OVMFFull
        (writeShellScriptBin "qemu-system-x86_64-uefi" ''
          qemu-system-x86_64 \
            -bios ${OVMFFull.fd}/FV/OVMF.fd \
            "$@"
        '')
      ];
    })
  ];
}
