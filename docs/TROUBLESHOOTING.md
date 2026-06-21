# Troubleshooting Guide

This document tracks known issues, technical limitations, and solutions for this NixOS configuration.

## 1. Security & Authentication

### Why doesn't my fingerprint unlock the GNOME Keyring?

**The Issue:** You can boot without a password (TPM2) and log in with your finger, but your browser passwords and SSH keys (GNOME Keyring) remain locked.

**Technical Rationale:**
The GNOME Keyring is an encrypted database that uses your **login password** as its decryption key. 
*   **The TPM2 Factor:** When the TPM2 chip unlocks your disk, it provides a cryptographic key, but it *does not* provide your human password.
*   **The Fingerprint Factor:** Biometric sensors store a mathematical hash, not your actual password string.
*   **The Handshake:** Because you didn't type a password during boot (due to TPM2) or during login (due to fingerprint), the system has no password in memory to "feed" to the GNOME Keyring.

**The Solution:**
If you need your saved passwords, simply log in to GDM once using your **password** instead of your fingerprint. This single entry will unlock both your session and your keyring.

## 2. Boot & TPM2

### TPM2 Policy Mismatch (Password prompt at boot)

**The Issue:** The system asks for a LUKS password at boot despite TPM2 being configured.

**Technical Rationale:**
The TPM2 "seals" your encryption key to the state of your computer (Platform Configuration Registers - PCRs). If you change certain settings, the TPM refuses to release the key to protect against tampering.
*   **PCR 0+7:** This is our default set. It binds to your Firmware (BIOS) and Secure Boot state.
*   **What breaks it:** A BIOS update, changing Secure Boot settings, or a major change in hardware.

**The Solution:**
1.  Type your manual disk password to boot.
2.  Wipe the old TPM2 slot:
    ```bash
    sudo systemd-cryptenroll /dev/disk/by-uuid/<your-disk-partition-uuid> --wipe-slot=tpm2
    ```
3.  Re-enroll the TPM2 chip:
    ```bash
    sudo systemd-cryptenroll /dev/disk/by-uuid/<your-disk-partition-uuid> --tpm2-device=auto --tpm2-pcrs=0+7
    ```
4.  Re-enroll the swap partition as well (repeat for its UUID).

## 3. Fingerprint Scanner

### "Module not found" or Fingerprint Timeout at GDM

**The Issue:** The fingerprint reader is ignored or shows an error in the logs.

**Technical Rationale:**
NixOS requires absolute Nix store paths for specialized PAM modules like `pam_fprintd.so` and `pam_gnome_keyring.so`. Using bare names in the configuration will cause GDM to fail when loading the authentication stack.

**The Solution:**
Ensure `modules/nixos/security/default.nix` uses `${pkgs.fprintd-tod}/lib/security/pam_fprintd.so` and similar interpolated paths.

## 4. User Not Visible in GDM After Rebuild

### User vanishes from GDM login screen after `nixos-rebuild switch`

**The Issue:** After a system rebuild, a previously working user account no longer appears on the GDM login screen. The user still exists in `/etc/passwd` and their home directory is intact, but GDM won't list them. Manual login via "Not listed?" also fails.

**Root Cause:** The user's account password was locked — the `/etc/shadow` entry shows `!` in the password hash field. GDM hides locked accounts (no valid authentication possible), and PAM denies login attempts for locked accounts.

**Why the password gets locked:** During `nixos-rebuild switch`, the NixOS activation script may reset the user's password to the locked state (`!`) if the user module defines `users.users.<name>` without an explicit `hashedPassword` and a nixpkgs update changes the activation behavior. The specific trigger was a `flake.lock` update (via merge or `nix flake update`) that pulled in a nixpkgs revision where the user activation logic treats `hashedPassword = null` (the default when `isNormalUser = true` is set) as an intent to lock the account on each activation.

**The Solution:**
```bash
passwd <username>
```
This writes a password hash to `/etc/shadow`, replacing `!`. The account is immediately unlocked and GDM will display it. The password survives subsequent rebuilds as long as `users.users.<name>.hashedPassword` remains unset (the activation script preserves existing passwords when no explicit hash is configured).

**To prevent recurrence**, add an explicit `hashedPassword` to `personal.nix`:
```nix
my.personal.hashedPassword = "$y$..."; # from mkpasswd or /etc/shadow
```
Then reference it in `users/default.nix`:
```nix
users.users.${personal.username} = {
  isNormalUser = true;
  hashedPassword = personal.hashedPassword;
  ...
};
```

## 5. Home Manager Activation Failure for Template User

### `home-manager-nixos.service` fails with "Connection reset by peer"

**The Issue:** After rebuild, the `home-manager-nixos.service` fails. The template `nixos` user (from the public `homes/x86_64-linux/nixos@nixos/` config) is not in `nix.settings.allowed-users`, so its HM activation cannot connect to the Nix daemon.

**The Solution:** In `systems/x86_64-linux/nixos/default.nix`:
```nix
snowfallorg.users.nixos.home.enable = config.my.personal.username == "nixos";
```
This disables HM generation for the template user when a custom user is active via `personal.nix`. The Snowfall Lib `snowfallorg.users.<name>` namespace maps to individual users discovered in `homes/`, so this only affects the template user, not the active custom user.
