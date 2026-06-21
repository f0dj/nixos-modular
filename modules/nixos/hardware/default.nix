/**
 * @file: modules/nixos/hardware/default.nix
 * @purpose: NixOS module for configuring graphics, audio, Bluetooth, and firmware.
 * @type: Module
 * @namespace: my
 */
{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.my.hardware;
in {
  # Hardware configuration module
  #
  # This module configures graphics, audio, Bluetooth, and other hardware settings.

  options.my.hardware = {
    graphics.enable = mkEnableOption "system graphics hardware configuration";
    audio.enable = mkEnableOption "audio configuration";
    bluetooth.enable = mkEnableOption "bluetooth configuration";
  };

  config = mkMerge [
    (mkIf cfg.graphics.enable {
      hardware = {
        graphics.enable = true; # Enable OpenGL support
        enableRedistributableFirmware = true; # Allow non-free firmware

        # NVIDIA graphics driver configuration
        nvidia = {
          modesetting.enable = true; # Required for Wayland compatibility
          powerManagement.enable = false;
          powerManagement.finegrained = false;
          open = false; # Use proprietary driver
          package = config.boot.kernelPackages.nvidiaPackages.stable;
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
          };
        };
      };

      # Realtek RTL8852BE WiFi/Bluetooth driver options
      boot.extraModprobeConfig = ''
        options rtw89_pci disable_clkreq=y disable_aspm_l1=y disable_aspm_l1ss=y
        options rtw89_core disable_ps_mode=y
      '';

      hardware.firmware = [pkgs.linux-firmware];
    })

    (mkIf cfg.audio.enable {
      # Disable PulseAudio
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;

      # PipeWire audio server configuration
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };
    })

    (mkIf cfg.bluetooth.enable {
      # Bluetooth configuration
      hardware.bluetooth = {
        enable = true; # Enable Bluetooth support
        powerOnBoot = true; # Power on Bluetooth on boot
        settings = {
          General = {
            Experimental = true; # Enable experimental features
            KernelExperimental = true;
          };
        };
      };
      # Bluetooth graphical client
      # services.blueman.enable = true;
    })
  ];
}
