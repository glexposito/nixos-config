# nixos-config

NixOS configuration for my machines.

## Hosts

- **workstation** — Desktop with AMD GPU, gaming, and .NET development
- **laptop** — Portable setup

## Structure

```
hosts/              Per-machine configuration
modules/            Shared modules
  desktop/          Desktop environment
    default.nix     Core apps and graphics
    gnome.nix       GNOME desktop, theming, and tools
    niri.nix        Niri compositor
    noctalia.nix    Noctalia shell
  ai.nix            AI tooling
  boot.nix          Bootloader
  dev.nix           Development tools
  dotnet.nix        .NET SDKs and runtimes
  gaming.nix        Steam and gaming
  shell.nix         Shell configuration
configuration.nix   Shared system settings
home.nix            User-level Home Manager configuration
```

## Usage

```bash
sudo nixos-rebuild switch --flake .#workstation
sudo nixos-rebuild switch --flake .#laptop
```

### Aliases

Once rebuilt, the following shell aliases are available:

- `nrs-w` — Rebuild and switch to the workstation configuration
- `nrs-l` — Rebuild and switch to the laptop configuration
- `nfu` — Update this flake's lock file
- `llms` — Start llama.cpp server with the configured model preset
- `cat` — Use `bat`
- `ls`, `ll`, `la`, `lla`, `lt` — eza-powered listing aliases
