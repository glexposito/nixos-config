{ lib, config, ... }:
let
  nixos = config.nixos;
in
{
  options.nixos.pc = lib.mkOption {
    type = lib.types.deferredModule;
    description = "What every one of my machines gets: the base, my account and every desktop.";
  };

  # A host without desktops (e.g. a server) can still list nixos.core and
  # nixos.guille on their own.
  config.nixos.pc = {
    imports = [
      nixos.core
      nixos.guille
      nixos.desktop
    ];
  };
}
