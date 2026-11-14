{ lib, config, ... }:
let
  nixos = config.nixos;
in
{
  options.nixos.pc = lib.mkOption {
    type = lib.types.deferredModule;
    description = "What every one of my machines gets: the base and my account.";
  };

  # No desktop here: each host picks its own (nixos.desktop-all,
  # nixos.desktop-noctalia, ...).
  config.nixos.pc = {
    imports = [
      nixos.core
      nixos.guille
    ];
  };
}
