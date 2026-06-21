# AGENTS.md

## Project Overview

This is an AI-managed modular NixOS and Home Manager configuration using **Nix Flakes** and **Snowfall Lib**. It configures a NixOS system (`nixos` host) with GNOME desktop, TPM2-boot, fingerprint login, and sops-nix secret management. **Snowfall Lib's `mkFlake`** handles all output generation — systems, homes, overlays, packages, and modules are auto-discovered under the `my` namespace. Never manually define outputs in `flake.nix`.

## Essential Commands

```bash
# Rebuild and activate system (with gitignored files via path: schema)
sudo nixos-rebuild switch --flake path:.#nixos --max-jobs 1 --show-trace

# Dry-run build check (no activation — use this to verify changes compile)
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --dry-run

# Home Manager only
home-manager switch --flake path:.

# Flake check (syntax + evaluation)
nix flake check

# Update flake inputs (MANUAL task — never auto-do this)
nix flake update
```

Use `path:.` not bare `.` so that gitignored files (`personal.nix`, `hardware-configuration.nix`) are copied to the Nix store. Bare `.` only includes tracked files.

## Architecture & Auto-Discovery

### Snowfall Lib Foundation

Snowfall Lib provides a structured, opinionated, and modular approach to Nix Flakes:

1. **Namespace:** All internal modules and packages are exposed under `my` (e.g., `config.my.desktop.enable`, `pkgs.my.custom-package`).
2. **Automatic Discovery:** Systems, homes, modules, packages, and overlays are auto-discovered from their respective directories.
3. **Convention over Configuration:** Follow Snowfall's directory-based module resolution. Never manually import files that Snowfall is designed to discover.

### Directory Structure

```
flake.nix                 — mkFlake entry point, inputs declaration
systems/x86_64-linux/     — per-host NixOS system configs (one dir per hostname)
 └── nixos/default.nix    — enables my.* modules, sets hostName, nix settings
homes/x86_64-linux/       — per-user home configs (format: username@hostname)
 └── nixos@nixos/default.nix — enables my.* home modules + nixvim plugins
modules/
 ├── nixos/               — system-level modules (NixOS)
 │   ├── boot/            — systemd-boot, TPM2 LUKS, initrd
 │   ├── desktop/         — GNOME, GDM, display drivers
 │   ├── hardware/        — graphics, audio, bluetooth
 │   ├── networking/      — NetworkManager, firewall
 │   ├── packages/        — system-wide packages
 │   ├── programs/        — Docker, Steam, Syncthing, virt, Firefox, vim
 │   ├── security/        — GPG, TPM2, PAM/fprintd, GNOME Keyring
 │   │   └── sops.nix     — sops-nix secret decryption config
 │   ├── services/        — fwupd, other system services
 │   └── users/           — user accounts, personal.nix options
 └── home/                — Home Manager user modules
     ├── editors/         — doom-emacs, nixvim (modular plugin tree), vscode
     ├── files/           — dotfile symlinks
     ├── programs/        — git, btop, direnv, gnome, ssh, wine-bottles
     ├── packages/        — user packages
     ├── scripts/         — custom shell scripts
     ├── session/         — session variables
     └── shell/           — zsh, aliases, history, Powerlevel10k
packages/                 — custom Nix packages (e.g., snacks-nvim buildVimPlugin)
overlays/                 — pinned package overlays (stable, emacs, libreoffice, etc.)
secrets/                  — sops-nix encrypted YAML files (gitignored except *.age)
configs/                  — misc config files
docs/                     — troubleshooting, migration logs, archive
```

### Auto-Discovery Reference

| Directory | What Snowfall discovers | Access pattern |
|-----------|------------------------|----------------|
| `systems/` | System configs | Enables `my.*` modules |
| `homes/` | Home Manager configs | Enables `my.*` home modules |
| `modules/nixos/` | NixOS modules (namespace `my`) | `config.my.<name>` |
| `modules/home/` | Home Manager modules (namespace `my`) | `config.my.<name>` |
| `packages/` | Custom packages | `pkgs.my.<name>` |
| `overlays/` | Overlay functions | Applied to nixpkgs |

## Snowfall User Management (CRITICAL)

Snowfall Lib automatically discovers users from the `homes/<arch>/<username>@<hostname>/` directory and creates a `snowfallorg.users.<username>` configuration namespace for each. Several Snowfall options default to `true` and have side effects:

| Option | Default | Effect |
|--------|---------|--------|
| `snowfallorg.users.<name>.create` | `true` | Creates `users.users.<name>` system user via NixOS |
| `snowfallorg.users.<name>.admin` | `true` | Adds user to `wheel` group (sudo access) |
| `snowfallorg.users.<name>.home.enable` | `true` | Enables Home Manager integration for this user |
| `snowfallorg.users.<name>.home.path` | `/home/<name>` | Custom home directory path |
| `snowfallorg.users.<name>.home.config` | `{}` | Pass Home Manager configuration from system level |

**When a user is discovered in `homes/` but should NOT be a real system user** (e.g., a template user like `nixos@nixos` when the actual user is `your-username`), you MUST disable all three: `create`, `admin`, and `home.enable`. Disabling only `home.enable` still leaves Snowfall creating the system user (`create=true`) and granting wheel membership (`admin=true`).

In Home Manager modules, Snowfall provides `snowfallorg.user.name` (the username) and `snowfallorg.user.home` (the home directory path). These replace hardcoded values. Home Manager modules also receive `osConfig` as a module argument, providing read-only access to the NixOS system configuration. Use `osConfig.my.*` to reference system-level options from home modules (e.g., `osConfig.my.personal.username`).

## Module Patterns

### Enable/Disable Toggle Pattern (universal)

Every module follows a strict boolean-gate pattern:

```nix
# modules/nixos/example/default.nix
{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.my.example;
in {
  options.my.example = {
    enable = mkEnableOption "example configuration";
  };

  config = mkIf cfg.enable {
    # actual NixOS/Home Manager settings here
  };
}
```

The enable toggles form a tree: `my.desktop.enable`, `my.programs.docker.enable`, `my.editors.nixvim.plugins.lsp.enable`, etc. Every module gate wraps its entire config in `mkIf cfg.enable`. Nixvim plugin modules use a double-gate: `mkIf (config.my.editors.nixvim.enable && cfg.enable)`.

### NDH Documentation Headers

Every `.nix` file **must** begin with a JSDoc-style header block:

```nix
/**
 * @file: relative/path/to/file.nix
 * @purpose: One-line purpose statement.
 * @type: Module | NixOS Module | Package | Overlay | System Configuration | Home Configuration
 * @namespace: my
 */
```

Followed by a module description comment block explaining the module's scope, and inline comments for the technical *why* behind non-obvious settings.

### MkOption Style

- Always include a `description` string for every `lib.mkOption`.
- Use `lib.mkEnableOption` where the option is a simple boolean.
- Prefer `lib.mkIf` for conditional config blocks, `lib.mkMerge` when combining multiple independent conditions.

## Coding Philosophy

### Behavioral Principles (Karpathy-Inspired)

Bias toward caution over speed. For trivial tasks, use judgment.

**1. Think Before Coding.** Don't assume. Don't hide confusion. Surface tradeoffs.
- State your assumptions explicitly.
- If multiple interpretations exist, present them — don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing.

**2. Simplicity First.** Minimum code that solves the problem. Nothing speculative.
- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No error handling for impossible scenarios.
- If you write 200 lines and it could be 50, rewrite it.
- Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

**3. Surgical Changes.** Touch only what you must. Clean up only your own mess.
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it — don't delete it.
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.
- The test: Every changed line should trace directly to the user's request.

**4. Goal-Driven Execution.** Define success criteria. Loop until verified.
- Transform tasks into verifiable goals: "Add validation" → "Write tests for invalid inputs, then make them pass".
- For multi-step tasks, state a brief plan with verify checkpoints.
- Strong success criteria enable independent looping. Weak criteria require constant clarification.

### Ponytail Methodology

"The best code is the code you never wrote. Write only what is necessary, cut the rest."

Before writing any code, pause at the first rung of the decision ladder that holds:

1. **Necessity:** Does this feature need to exist at all? If speculative, skip it (YAGNI).
2. **Standard Library:** Can the Nix/NixOS standard library (`lib`, builtins) do it? Use it.
3. **Native Platform Feature:** Does the underlying platform/module support it natively? (e.g., native NixOS service configurations, default options).
4. **Already-Installed Dependency:** Can we reuse an existing flake input or module option? Do not add new inputs or dependencies for what a few lines of configuration can achieve.
5. **Conciseness:** Can it be done in a single line or minimal declaration?
6. **Minimalism:** Only after these checks, write the absolute minimum code that works.

Rules of laziness:
- **No unrequested abstractions:** No custom configuration options for settings that never change. No multi-file scaffolding "for later".
- **Deletion over addition:** Favor removing unused code/configurations orphaned by your changes over adding new ones. Do not touch pre-existing dead code. The shortest working diff wins.
- **Preservation Overrides Deletion:** The preservation of active, user-configured settings always overrides any line-count reduction or deletion goals.
- **Stealth and Boring:** Write simple, boring code. Clever code is a liability.
- **Document Shortcuts:** Mark deliberate simplifications or shortcuts with a `# ponytail:` comment (e.g., `# ponytail: fallback user`). Name the ceiling or reason.
- **Preserve Safety:** Never compromise on validation, security boundary setups, or data-loss handling for the sake of line-count reduction.

## Code Conventions

- **Formatter:** alejandra-style (trailing commas, multi-line lists, `with lib;` at module scope)
- **Strings:** Prefer Nix string interpolation `${var}` over `+` concatenation
- **Paths:** Use relative paths `./file.nix` for same-dir imports, `../sibling.nix` for up-one
- **Arc arguments:** Include `pkgs`, `lib`, `config`, `inputs` even if unused — some warnings are expected
- **Comments:** Inline `#` explain *why*, not *what*. Use `# TODO(config):` or `# TODO(hardware):` for placeholders
- **ponytail comment:** Mark deliberate simplifications as `# ponytail: <reason>`

## Personal Info & Gitignored Files (CRITICAL)

These files are **gitignored** and must **NEVER** be staged or committed:

- `modules/nixos/users/personal.nix` — username, name, email, timezone, Syncthing layout
- `homes/x86_64-linux/your-username@nixos/` — personal Home Manager toggles
- `systems/x86_64-linux/nixos/hardware-configuration.nix` — LUKS partition UUIDs
- `personal-changelog.md` — local changelog

The `personal.nix` is conditionally imported: `if builtins.pathExists ./personal.nix then ./personal.nix else ./personal.nix.example`. The same pattern applies to `hardware-configuration.nix`.

When building locally with private files, use `path:.` flake schema. Before committing, always run `git diff --cached` and scan for personal usernames or partition UUIDs. Any changes to gitignored personal configs must be documented manually in `personal-changelog.md` to preserve their history locally.

## Git & Remote Protocol

Two remotes with a dual-push workflow:

- **`origin`** (private SSH) — daily commits go to `main`, standard `git push`
- **`public`** — clean commits are cherry-picked via `git push-public` alias, which automatically cherry-picks new commits (since the `public-sync` tag) onto a clean branch and pushes, maintaining history without leaking private ancestors

Rules:
- Never push automatically
- Commits follow **Conventional Commits**: `type(scope): subject` with technical rationale in body
- Because new commits are cherry-picked to the public remote, you must strictly prevent committing any private information (username, email, disk UUIDs) to `main`

### Commit Workflow

1. **Pre-Commit:** Run `git status` and `git diff HEAD`. Stage changes with `git add`.
2. **Commit:** Create a detailed commit with technical rationale (the *why* and technical impact).
3. **Post-Commit:** Confirm clean state via `git status`.
4. **Push:** `git push` to origin (private). For public: `git push-public`.

## Secret Management (sops-nix)

- Secrets live in `secrets/secrets.yaml` (encrypted with age)
- Two age keys in `.sops.yaml`: user key + system key
- At build time, `modules/nixos/security/sops.nix` defines which secrets to decrypt and their file ownership
- Decrypted secrets appear at `/run/secrets/<name>` on the target system
- Never expose decrypted secret contents in logs, commits, or outputs
- To disable secrets entirely for a new deployment, set `my.security.enable = false` in `personal.nix`

## Overlays & Pinned Packages

**Pins are never registered in `flake.nix`** — they go in `overlays/<name>/default.nix` and are auto-discovered by Snowfall. Always place overlays within the `overlays/` directory. For channel-specific pinning (like stable), use a dedicated overlay (e.g., `overlays/stable/default.nix`) that imports the target channel via `inputs.<channel-name>`.

Do not unpin without understanding why each pin exists. The `stable` overlay exposes `pkgs.stable` (from `nixpkgs-stable` input).

### Current Pins

| Package | Overlay | Commit / Channel | Date | Reason |
|---------|---------|-----------------|------|--------|
| emacs | `overlays/emacs/` | `f85952894cfbc4f6dae2f12e28cefc6bdcbb6ece` | 2026-04-25 | Fix tree-sitter patch conflict |
| libreoffice | `overlays/libreoffice/` | nixpkgs `1c3fe55a` | 2026-05-07 | Avoid lengthy recompilation on updates |
| digikam | `overlays/digikam/` | nixpkgs `a799d3e` | 2026-06-10 | Avoid lengthy recompilation on updates |
| openldap | `overlays/openldap/` | stable | 2026-04-25 | Bypass test017-syncreplication-refresh failure in unstable |
| scid-vs-pc | `overlays/scid-vs-pc/` | stable | 2026-04-25 | Bypass patch failure in unstable |
| teams-for-linux | `overlays/stable/` | stable | 2026-04-25 | Bypass electron build failure in unstable |

## NixVim Plugin Architecture

NixVim is configured as a tree of home modules under `modules/home/editors/nixvim/`:

```
nixvim/
├── default.nix           — orchestrator: imports all core + plugin modules, gates on my.editors.nixvim.enable
├── core/
│   ├── autocmd.nix, keys.nix, sets.nix, treesitter-queries.nix
└── plugins/
    ├── <plugin>.nix      — one file per plugin, each with its own enable option
    └── utils.nix         — utility plugins grouped (oil, which-key, comment, etc.)
```

Each plugin module has options under `my.editors.nixvim.plugins.<name>` and its config is gated on **both** the parent `nixvim.enable` and its own `enable`. The orchestrator `default.nix` passes `inputs` to all sub-modules via `_module.args`.

To add a plugin: create its file under `plugins/`, declare options, gate config, and import it in `default.nix`.

## Documentation Mandates (NDH Framework)

1. **Standardized Headers:** Every `.nix` file MUST begin with an NDH header block (`@file`, `@purpose`, `@type`, `@namespace`).
2. **Verbose Options:** Always include a `description` for `lib.mkOption`.
3. **The "Why" Rule:** Inline comments MUST explain technical rationale for non-standard configurations.
4. **Placeholder Protocol:** Use `# TODO(config):` for thin modules to signal extensibility.
5. **Auto-Maintenance:** Verify NDH compliance when modifying any file.

## Operational Constraints

1. **Flakes Mandate:** Use Nix Flakes exclusively. Legacy channels are prohibited unless technically unavoidable (must explain why).
2. **Conflict Protocol:** If a requested change conflicts with an upstream default or existing setting, **STOP** and ask the user for a decision. Do not use `lib.mkForce` without explicit approval.
3. **Lockfile Integrity:** Never modify `flake.lock` (e.g., `nix flake update`) automatically. This is a manual user task.
4. **Secret Management:** Detect and respect `sops-nix`. Never expose decrypted secrets.
5. **Preservation Mandate:** Never remove functionalities from the configuration unless absolutely required for system stability or explicitly directed. Prefer fixes over removals.
6. **Read-Before-Write:** Verify file state with `view`/`glob` before generating code. Do not assume file contents.
7. **No Imperative Actions:** All package management must be declarative. Never suggest `nix-env`.
8. **Snowfall Integrity:** Do not attempt to bypass Snowfall's module system or manually define outputs in `flake.nix` that should be managed by `mkFlake`.
9. **No Auto-Commits or Pushes:** Create commits on explicit request only. Never push automatically.
10. **No System Rebuilds:** Do not run `nixos-rebuild switch` or `nixos-rebuild boot`. The user handles system activation and rebuilding manually.

## Workflow Protocol

1. **Analysis:** Scan request → Gather context (`glob`/`view`) → Check `sops-nix` → Detect architecture.
2. **Planning:** Formulate a plan with verifiable goals. If conflicts or ambiguities arise, pause for user decision.
3. **Implementation:**
   - Write/Update `.nix` files using detected formatting style.
   - **Git-Centric Documentation:** Manual "Revisions" in README.md are prohibited.
   - **Conventional Commits:** Every change MUST follow `type(scope): subject`.
   - **Technical Rationale:** The commit body must explain the *why* and the technical impact.
   - Check syntax (`nix flake check`).
   - **Dry-Run Evaluation Requirement:** Run `nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --dry-run` to verify compilation.

## Testing Changes

After modifying Nix files, verify:

```bash
# Syntax and evaluation check (fast)
nix flake check

# Full dry-run build (catches module errors)
nix build path:.#nixosConfigurations.nixos.config.system.build.toplevel --dry-run
```

The project has no test suite; correctness is verified through `nix flake check` and dry-run builds.

## Known Gotchas

### User password locked after rebuild

If a user disappears from GDM after `nixos-rebuild switch`, check `/etc/shadow`. A `!` in the password field means the account is locked. This happens when a nixpkgs update changes the activation behavior and the user module defines `users.users.<name>` via `isNormalUser = true` without an explicit `hashedPassword`. Fix: `passwd <username>`. See `docs/TROUBLESHOOTING.md#4-user-not-visible-in-gdm-after-rebuild`.

### Template user HM service failure

The `home-manager-nixos.service` fails when the template `nixos` user (from `nixos@nixos/`) is not in `nix.settings.allowed-users`. This is expected and suppressed by `snowfallorg.users.nixos.home.enable = config.my.personal.username == "nixos"` in the system config. Do not remove this line — it targets only the template user, not the active custom user.

### `snowfallorg.users.<name>` scoping

`snowfallorg.users.nixos` refers to the user discovered from `homes/x86_64-linux/nixos@nixos/` — NOT the host-level namespace. Setting `home.enable` here only affects that specific Snowfall-discovered user. The custom user (e.g., `your-username`) has its own `snowfallorg.users.your-username` namespace and is unaffected.

## NixOS Documentation

Useful resources for NixOS, Nixpkgs, and Home Manager:

### Core Reference
- **Nix Reference Manual:** https://nixos.org/manual/nix/stable/
- **NixOS Manual:** https://nixos.org/manual/nixos/stable/
- **Nixpkgs Manual:** https://nixos.org/manual/nixpkgs/stable/
- **Home Manager Manual:** https://nix-community.github.io/home-manager/

### Search & Local Docs
- **Options Search:** https://search.nixos.org/options
- **Packages Search:** https://search.nixos.org/packages
- **Local options:** `man home-configuration.nix`
- **Home Manager manual:** `home-manager manual`
