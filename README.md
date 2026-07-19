# nixos-config

NixOS configuration for my machines.

## Hosts

- **workstation** — Desktop with AMD GPU, gaming, .NET development, GNOME + Hyprland
- **zenbook** — ASUS Zenbook portable setup, GNOME + Hyprland

## Structure

- `flake.nix` defines the flake inputs and host outputs.
- `configuration.nix` contains shared NixOS settings imported by every host.
- `home/` contains user-level Home Manager configuration.
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

### Username

The username is defined once, as `username` in the `let` block of `flake.nix`, and threaded through to every module that needs it (`configuration.nix`, `modules/packages.nix`, `home/default.nix`) via `specialArgs`/`extraSpecialArgs`. If you're forking this for your own machine, change that one line:

```nix
# flake.nix
username = "guille";
```

### Other personal details

A few more personal values aren't parameterized, since they're single-use leaf values rather than something referenced across files. Update these directly if forking:

- `configuration.nix` — `description = "Guillermo"` (GECOS display name)
- `home/git.nix` — `user.name` and `user.email`
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

Hyprland user overrides live in `dots/caelestia/` and are deployed to `~/.config/caelestia/` via Home Manager. The upstream Hyprland Lua config comes from the `caelestia-dots` flake input and is symlinked to `~/.config/hypr/`.

### Aliases

Once rebuilt, the following shell aliases are available:

- `nrs-w` — Rebuild and switch to the workstation configuration
- `nrs-z` — Rebuild and switch to the zenbook configuration
- `nfu` — Update this flake's lock file
- `llms` — Start llama.cpp server with the configured model preset
- `ff` — Run fastfetch with the example 32 preset
- `cat` — Use `bat`
- `ls`, `ll`, `la`, `lla`, `lt` — eza-powered listing aliases
