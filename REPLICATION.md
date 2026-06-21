# NixOS Configuration Replication Guide

This guide describes how to clone, customize, and build this NixOS configuration on your own machine.

---

## Prerequisite: Nix & Nix Flakes
Ensure you have Nix installed with Flakes enabled. If not, add this to your `/etc/nixos/configuration.nix`:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

---

## Step 1: Clone the Repository
Clone this repository to your local machine:
```bash
git clone <repository-url> nixos-config
cd nixos-config
```

---

## Step 2: Configure Personal Details
We isolate all personal details into a gitignored file (`personal.nix`) so you don't commit your data back to git.

1.  Copy the template configuration file:
    ```bash
    cp modules/nixos/users/personal.nix.example modules/nixos/users/personal.nix
    ```
2.  Edit `modules/nixos/users/personal.nix` and set your username, email, timezone, locales, and editor settings:
    ```nix
    my.personal = {
      username = "your-username";
      name = "Your Display Name";
      email = "your-email@domain.com";
      timeZone = "America/New_York"; # Set timezone
      defaultLocale = "en_US.UTF-8";
      extraLocale = "en_US.UTF-8";
      inputMethod = "us";            # Default Emacs input method
      orgDirectory = "~/Org";        # Path to Org mode files
    };
    ```

---

## Step 3: Match Hostname & Username Directories
Snowfall Lib automatically maps system and home configurations to hostnames and usernames using the directory structures.

1.  **Rename System host (optional):**
    If your machine's hostname is not `nixos`, rename the directory:
    ```bash
    mv systems/x86_64-linux/nixos systems/x86_64-linux/<your-hostname>
    ```
2.  **Rename Home configuration:**
    Rename the directory under `homes/` to match your username and hostname:
    ```bash
    mv homes/x86_64-linux/nixos@nixos homes/x86_64-linux/<your-username>@<your-hostname>
    ```

---

## Step 4: Generate Hardware Configuration
Generate the hardware configuration specific to your target machine:
```bash
nixos-generate-config --show-hardware-config > systems/x86_64-linux/<your-hostname>/hardware-configuration.nix
```
Ensure that if you have LUKS partitions, swap devices, or hibernation resume devices, they are configured correctly inside the generated `hardware-configuration.nix` file.

---

## Step 5: Configure Secret Management (SOPS-nix)
By default, `sops-nix` handles secret management. If you don't want to use secrets or don't have keys:
1.  Open your `modules/nixos/users/personal.nix` and add:
    ```nix
    my.security.enable = false; # Completely disables sops-nix and secret requirements
    ```
2.  If you want to keep secrets:
    - Generate an age key: `age-keygen -o ~/.config/sops/age/keys.txt`
    - Retrieve the public key and put it into `.sops.yaml` in the root of the project.
    - Encrypt your secrets file: `sops secrets/secrets.yaml`

---

## Step 6: Build and Switch
Because `personal.nix` is gitignored and untracked, you **must** build the system using the `path:.` flake schema so Nix copies all files in the directory (including gitignored/untracked ones) into the evaluation store:

```bash
# Build the top-level system configuration
nixos-rebuild dry-activate --flake path:.#<your-hostname>

# To switch and apply the changes
sudo nixos-rebuild switch --flake path:.#<your-hostname>
```
