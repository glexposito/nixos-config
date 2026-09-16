# nixos-config

NixOS configuration for my machines.

## Hosts

- **workstation** — Desktop with AMD GPU, GNOME + Hyprland + Mango (see `hosts/workstation/default.nix` for enabled profiles)
- **zenbook** — ASUS Zenbook portable setup, GNOME + Hyprland + Mango

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

## Usage

Clone this repository, or fork it first if adapting it for another machine, then run the following commands from the repository root:

```bash
git clone https://github.com/glexposito/nixos-config.git
cd nixos-config
```

### Users

Each account has a regular NixOS module under `users/`:

- `users/guille.nix` is imported by `configuration.nix`, so Guille is available on both machines. He uses Fish, has admin access, and gets Docker access when the host enables the Docker profile.
- `users/sol.nix` is imported only by `hosts/zenbook/default.nix`, so Sol is available only on the Zenbook. She uses the default Bash shell and has network management access.

Both accounts receive the shared `home/` configuration through `home-manager.sharedModules` in `flake.nix`. Home Manager derives each username and home directory from the corresponding NixOS account.

To add an account, create `users/<name>.nix` with its `users.users.<name>` settings and `home-manager.users.<name>` configuration, then import it from the desired host. To make an account available on every host, import it from `configuration.nix`.

After the first rebuild on the Zenbook, set Sol's login password:

```bash
sudo passwd sol
```

Existing passwords are retained with NixOS's default `users.mutableUsers = true`. Keep Guille's username, home directory, and state versions unchanged when adding users.

### Other personal details

Update these values directly if forking:

- `users/<name>.nix` — account name, display name, groups, shell, and Git identity. Sol's configured Git email is `sol@apollo.local`; replace it if she needs a different commit identity.
- `configuration.nix` — `time.timeZone` and `i18n.defaultLocale`

### Hardware configuration

The `hosts/*/hardware-configuration.nix` files are machine-specific. Each one should contain the actual generated hardware config for that host. Before rebuilding, put the target machine's generated hardware config in the matching host folder. Run these commands from the repo root, replacing `<host>` with `workstation` or `zenbook`.

If the machine already has a generated hardware config, copy it first:

```bash
cp /etc/nixos/hardware-configuration.nix hosts/<host>/hardware-configuration.nix
```

If that file does not exist, generate it directly into the host folder:

```bash
sudo nixos-generate-config --show-hardware-config > hosts/<host>/hardware-configuration.nix
```

Do not reuse another machine's generated file unless the disks, filesystems, and hardware are intentionally the same.

Also review `hosts/<host>/default.nix` before reusing a host profile. It may contain hardware-specific defaults that are not in `hardware-configuration.nix`, such as the workstation AMD GPU settings.

For a new machine, it is fine to start with only the shared imports and `networking.hostName`, then add host-specific settings as needed.

```bash
sudo nixos-rebuild switch --flake .#workstation
sudo nixos-rebuild switch --flake .#zenbook
```

### Desktop profiles

Desktop environments are opt-in per host via `profiles.<name>.enable`:

- **GNOME** — `profiles.gnome.enable = true`
- **Hyprland** — `profiles.hyprland.enable = true` (uses [Caelestia Shell](https://github.com/caelestia-dots/shell) with Lua config from [caelestia-dots](https://github.com/caelestia-dots/caelestia))
- **Mango** — `profiles.mango.enable = true` (uses [mango](https://github.com/mangowm/mango), a dwl-based Wayland compositor, with [Noctalia Shell](https://github.com/noctalia-dev/noctalia))

Hyprland user overrides live in `dots/caelestia/` and are deployed to `~/.config/caelestia/` via Home Manager. The upstream Hyprland Lua config comes from the `caelestia-dots` flake input and is symlinked to `~/.config/hypr/`.

Mango and Noctalia are both configured in `home/mango.nix`: mango's config sources its own packaged defaults (`/etc/mango/config.conf`, installed by `modules/desktop/mango.nix`) via `source-optional`, with keybinds and visual tuning layered on top; Noctalia's settings (theme, wallpaper, plugins) are declared under `programs.noctalia.settings`. Both compositors run alongside each other and are selectable per-session from the greetd login screen.

### Other profiles

Additional features are opt-in per host using the same `profiles.<name>.enable` pattern:

- **AI** — `profiles.ai.enable = true` installs llama.cpp with Vulkan support.
- **.NET** — `profiles.dotnet.enable = true` installs Rider and the configured .NET SDKs.
- **Gaming** — `profiles.gaming.enable = true` enables Steam, Gamescope and Gamemode.
- **Docker** — `profiles.docker.enable = true` enables Docker and installs Docker Compose and Lazydocker. User modules grant Docker access individually; currently only Guille receives it.
- **Podman** — `profiles.podman.enable = true` enables Podman with Docker compatibility and installs Podman Compose and Podman Desktop.
- **k3s** — `profiles.k3s.enable = true` installs an on-demand k3s server with kubectl, Helm and k9s. The service does not start automatically.

Docker and Podman are separate profiles; enable only the container runtime required by a host.

### Git tooling

Home Manager configures Git, GitHub CLI and Lazygit in `home/git.nix`. Each account's Git identity is set in `users/<name>.nix`.

### Aliases

Once rebuilt, the following aliases are available in Fish:

- `nrs-w` — Rebuild and switch to the workstation configuration
- `nrs-z` — Rebuild and switch to the zenbook configuration
- `nfu` — Update this flake's lock file
- `llms` — Start llama.cpp server with the configured model preset
- `ff` — Run fastfetch with the example 32 preset
- `cat` — Use `bat`
- `ls`, `ll`, `la`, `lla`, `lt` — eza-powered listing aliases
