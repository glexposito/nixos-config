{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.zenbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware-configuration.nix
      nixos.core
      nixos.guille
      nixos.sol

      nixos.desktop

      {
        networking.hostName = "apollo";

        monitors = [
          {
            output = "eDP-1";
            width = 2880;
            height = 1800;
            refresh = 90;
            scale = 1.25;
          }
        ];
      }
    ];
  };
}
