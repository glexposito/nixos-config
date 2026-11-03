{ config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  # Every desktop, so a host can list one name instead of four. The individual
  # ones (nixos.gnome, nixos.mango, ...) still exist for a host that wants
  # only some of them.
  flake.modules.nixos.desktop = {
    imports = [
      nixos.gnome
      nixos.hyprland
      nixos.mango
      nixos.umbriel
    ];
  };
}
