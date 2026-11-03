{ inputs, config, ... }:
let
  nixos = config.flake.modules.nixos;
in
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      ./_hardware-configuration.nix
      nixos.core
      nixos.guille

      nixos.ai
      nixos.dotnet
      nixos.gaming
      nixos.desktop

      {
        networking.hostName = "mother";

        monitors = [
          {
            output = "DP-3";
            width = 3840;
            height = 2160;
            refresh = 240;
            scale = 1;
          }
        ];

        boot.kernel.sysctl."vm.swappiness" = 60;

        hardware.amdgpu.initrd.enable = true;
        services.xserver.videoDrivers = [ "amdgpu" ];
      }
    ];
  };
}
