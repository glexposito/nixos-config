{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  modules.ai.enable = true;
  modules.dotnet.enable = true;
  modules.gaming.enable = true;
  modules.podman.enable = true;

  networking.hostName = "nixos";

  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
