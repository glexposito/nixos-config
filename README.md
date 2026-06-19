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
    gnome.nix       GNOME theming and tools
    niri.nix        Niri compositor
    noctalia.nix    Noctalia shell
  ai.nix            AI tooling
  boot.nix          Bootloader
  dev.nix           Development tools
  dotnet.nix        .NET SDKs and runtimes
  gaming.nix        Steam and gaming
  shell.nix         Shell configuration
configuration.nix   Shared system settings
home.nix            Home Manager configuration
```

## Usage

```bash
sudo nixos-rebuild switch --flake .#workstation
sudo nixos-rebuild switch --flake .#laptop
```
