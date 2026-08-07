{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    ai.enable = true;
    dotnet.enable = true;
    gaming.enable = true;
    gnome.enable = true;
    hyprland.enable = true;
    podman.enable = true;
    docker.enable = false;
    k3s.enable = true;
  };

  networking.hostName = "mother";

  boot.kernel.sysctl."vm.swappiness" = 60;

  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
