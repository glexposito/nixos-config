# nixos-config

NixOS configuration for my machines.

## Hosts

These are my machines; each one lives in `hosts/<host>/`:

- **workstation** (`mother`) — desktop with AMD GPU
- **zenbook** (`apollo`) — ASUS Zenbook laptop

Enabled profiles are listed in each host's `default.nix`.

## Usage

1. Clone the repo:

   ```bash
   git clone https://github.com/glexposito/nixos-config.git
   cd nixos-config
   ```

2. Copy the hardware config (`<host>` is `workstation` or `zenbook`):

   ```bash
   cp /etc/nixos/hardware-configuration.nix hosts/<host>/hardware-configuration.nix
   ```

3. Rebuild:

   ```bash
   sudo nixos-rebuild switch --flake .#<host>
   ```

### Using it on another machine

1. Copy `hosts/zenbook/` to `hosts/<name>/`, set `networking.hostName`, and remove the `users/sol.nix` import.
2. Add a `nixosConfigurations.<name>` entry in `flake.nix`.
3. Replace `users/guille.nix` with your own `users/<you>.nix` and update the import in `configuration.nix`. Also set `time.timeZone` and `i18n.defaultLocale` there.
4. `git add` the new files (flakes ignore untracked files), then follow the steps above.

## Structure

- `flake.nix` defines the flake inputs and host outputs.
- `configuration.nix` contains shared NixOS settings imported by every host.
- `home/` contains user-level Home Manager configuration.
- `users/` contains each account's NixOS settings and Git identity.
- `hosts/` contains per-machine configuration, including generated hardware files.
- `modules/` contains reusable system profiles and feature modules that hosts can opt into.
- `dots/` contains dotfiles managed by Home Manager (e.g. Caelestia/Hyprland overrides).
- `utils/` contains personal scripts and reference configs for things not covered by the declarative system configuration (e.g. llama.cpp model presets).

Host files should stay small and mostly describe machine-specific choices. Shared behavior belongs in `configuration.nix`, `home/`, or a module under `modules/`.

## Users

Each account has a regular NixOS module under `users/`:

- `users/guille.nix` is imported by `configuration.nix`, so Guille is available on both machines. He uses Fish, has admin access, and gets Docker access when the host enables the Docker profile.
- `users/sol.nix` is imported only by `hosts/zenbook/default.nix`, so Sol is available only on the Zenbook. She uses Fish with the shared shell aliases and has network management access.

Both accounts receive the shared `home/` configuration through `home-manager.sharedModules` in `flake.nix`. Home Manager derives each username and home directory from the corresponding NixOS account.

To add an account, create `users/<name>.nix` with its `users.users.<name>` settings and `home-manager.users.<name>` configuration, then import it from the desired host. To make an account available on every host, import it from `configuration.nix`.

After adding a new user and rebuilding the target host, set their login password. Replace `username` with the new account's name:

```bash
sudo passwd username
```

Existing passwords are retained with NixOS's default `users.mutableUsers = true`.

## Desktop profiles

Desktop environments are opt-in per host via `profiles.<name>.enable`:

- **GNOME** — `profiles.gnome.enable = true`
- **Hyprland** — `profiles.hyprland.enable = true` (uses [Caelestia Shell](https://github.com/caelestia-dots/shell) with Lua config from [caelestia-dots](https://github.com/caelestia-dots/caelestia))
- **Mango** — `profiles.mango.enable = true` (uses [mango](https://github.com/mangowm/mango), a dwl-based Wayland compositor, with [Noctalia Shell](https://github.com/noctalia-dev/noctalia))

Hyprland user overrides live in `dots/caelestia/` and are deployed to `~/.config/caelestia/` via Home Manager. The upstream Hyprland Lua config comes from the `caelestia-dots` flake input and is symlinked to `~/.config/hypr/`.

Mango and Noctalia are both configured in `home/mango.nix`: mango's config sources its own packaged defaults (`/etc/mango/config.conf`, installed by `modules/desktop/mango.nix`) via `source-optional`, with keybinds and visual tuning layered on top; Noctalia's settings (theme, wallpaper, plugins) are declared under `programs.noctalia.settings`. Both compositors run alongside each other and are selectable per-session from the greetd login screen.

## Git tooling

Home Manager configures Git, GitHub CLI and Lazygit in `home/git.nix`. Each account's Git identity is set in `users/<name>.nix`.

## Other profiles

Additional features (AI, .NET, gaming, containers, k3s, virtualisation, …) are opt-in per host using the same `profiles.<name>.enable` pattern. See `modules/*.nix` for the available profiles and what each one installs.

## Aliases

Fish aliases are defined in `home/shell.nix`.
