{ lib, config, ... }:
let
  nixos = config.nixos;
in
{
  options.nixos.desktop = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Every desktop: GNOME, Hyprland, Mango and Umbriel.";
  };

  # Every desktop, so a host can list one name instead of four. The individual
  # ones (nixos.gnome, nixos.mango, ...) still exist for a host that wants
  # only some of them.
  config.nixos.desktop = {
    imports = [
      nixos.gnome
      nixos.hyprland
      nixos.mango
      nixos.umbriel
    ];
  };
}
