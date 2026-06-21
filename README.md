# nixos-config

**A personal NixOS + Home Manager configuration — modular, documented, and AI-assisted.**

This is the configuration that runs my laptop. GNOME desktop, TPM2-boot (no password at startup), fingerprint login, encrypted secrets, and a heavily customized Neovim. Built with Nix Flakes and [Snowfall Lib](https://github.com/snowfallorg/lib).

It's also written to be readable by AI agents — there's an [`AGENTS.md`](AGENTS.md) that describes the architecture, conventions, and constraints so an AI can make surgical edits, run validation, and produce sensible commits without hand-holding. Not magic, just documentation.

## What's in here

| Area | Details |
|------|---------|
| **Boot** | systemd-boot, TPM2 LUKS auto-unlock (zero-password boot) |
| **Desktop** | GNOME + GDM, Intel/NVIDIA hybrid graphics |
| **Auth** | Fingerprint (Goodix driver) + password, GNOME Keyring unlock |
| **Secrets** | sops-nix with age encryption, decrypted to `/run/secrets/` |
| **Editor** | NixVim with 25+ modular plugins, Doom Emacs |
| **Shell** | zsh + Powerlevel10k + custom aliases |
| **System** | Docker, Syncthing, Steam, virt-manager, libreoffice (pinned), digikam (pinned) |
| **Docs** | Every `.nix` file has a JSDoc header and rationale comments |

## Directory structure

```
flake.nix              — mkFlake entry point (no manual outputs)
systems/               — per-host NixOS configs (auto-discovered)
homes/                 — per-user Home Manager configs
modules/nixos/         — system modules (boot, desktop, security, etc.)
modules/home/          — user modules (shell, editors, programs)
packages/              — custom Nix packages
overlays/              — pinned package versions (emacs, libreoffice, etc.)
secrets/               — sops-nix encrypted YAML (gitignored)
```

Every module follows one pattern:

```nix
options.my.<name>.enable = mkEnableOption "...";
config = mkIf cfg.enable { /* actual settings */ };
```

No magic toggles. No hidden state. Disable what you don't use.

## AI-assisted workflow

The `AGENTS.md` file at the repo root is ~300 lines of architecture docs, naming conventions, patterns, and operational rules. An AI agent (Crush, Claude, etc.) that reads it can:

- Create or edit `.nix` modules in the right directories
- Wire up `my.*` namespace options correctly
- Run `nix flake check` and dry-run builds
- Produce conventional commits with technical rationale
- Avoid touching secrets, lockfiles, or personal data

What it can't do: activate the system, update flake inputs, or test on hardware. Those are manual steps.

## Getting started (for your own fork)

```bash
git clone <your-fork-url> nixos-config && cd nixos-config

# Set up your personal details
cp modules/nixos/users/personal.nix.example modules/nixos/users/personal.nix
# Edit: username, name, email, timezone, locale

# Generate hardware config
nixos-generate-config --show-hardware-config > systems/x86_64-linux/nixos/hardware-configuration.nix

# Build check
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --dry-run

# Apply
sudo nixos-rebuild switch --flake path:.#nixos
```

Use `path:.` (not bare `.`) so gitignored files like `personal.nix` are included in the Nix store.

**Adapting to your hardware:** The boot, graphics, and fingerprint modules are hardware-specific. You'll likely need to adjust or disable them. At minimum, review `modules/nixos/boot/`, `modules/nixos/hardware/`, and `modules/nixos/security/default.nix`.

## Security notes

- **Boot:** TPM2 seals the LUKS key to PCRs 0+7 (firmware + Secure Boot). If the system is tampered with, the TPM won't release the key and you'll be prompted for a password.
- **Fingerprint:** Logging in with a fingerprint gives you a session but leaves the GNOME Keyring locked (fingerprint hashes can't derive the encryption key). Log in with your password once to unlock saved credentials.
- **Secrets:** Set `my.security.enable = false` in `personal.nix` to disable sops-nix entirely if you don't need it.

## Pinned packages

Some packages are pinned to specific nixpkgs commits to avoid frequent recompilation or bypass build failures:

| Package | Reason |
|---------|--------|
| emacs | Fix tree-sitter patch conflict in unstable |
| libreoffice | Avoid lengthy recompilation on updates |
| digikam | Avoid lengthy recompilation on updates |
| scid-vs-pc, openldap, teams-for-linux | Bypass build failures in unstable (pinned to stable channel) |

If a pin breaks, update the commit hash in its overlay file under `overlays/<name>/default.nix`.

## Troubleshooting

See [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) for common issues: user vanishes from GDM, fingerprint doesn't unlock keyring, TPM2 prompts after BIOS update, Home Manager activation failures.

## License

MPL 2.0 — see [`LICENSE`](LICENSE).
