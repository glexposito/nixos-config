{ inputs, config, ... }:
let
  nixos = config.nixos;
in
{
  flake.nixosConfigurations.zenbook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware-configuration.nix
      nixos.pc
      nixos.sol

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
