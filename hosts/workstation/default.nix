{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    ai.enable = true;
    dotnet.enable = true;
    gaming.enable = true;
    podman.enable = true;
  };

  networking.hostName = "mother";

  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
