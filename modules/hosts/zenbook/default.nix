{ inputs, config, ... }:
let
  nixos = config.nixos;
in
{
  flake.nixosConfigurations.zenbook = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware-configuration.nix
      nixos.pc
      nixos.desktop-noctalia
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
