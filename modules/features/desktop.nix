{ lib, config, ... }:
let
  nixos = config.nixos;
in
{
  options.nixos.desktop-all = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Every desktop: GNOME, Hyprland, Mango and Umbriel.";
  };
  options.nixos.desktop-noctalia = lib.mkOption {
    type = lib.types.deferredModule;
    description = "The Noctalia desktops: Mango and Umbriel.";
  };

  # Bundles so a host can list one name instead of several. The individual
  # ones (nixos.gnome, nixos.mango, ...) still exist for a host that wants
  # a different mix.
  config.nixos.desktop-all = {
    imports = [
      nixos.gnome
      nixos.hyprland
      nixos.desktop-noctalia
    ];
  };

  config.nixos.desktop-noctalia = {
    imports = [
      nixos.mango
      nixos.umbriel
    ];
  };
}
