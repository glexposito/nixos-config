{ inputs, config, ... }:
let
  nixos = config.nixos;
in
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./_hardware-configuration.nix
      nixos.pc
      nixos.desktop-all

      nixos.ai
      nixos.gaming
      nixos.podman

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
