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
  };

  networking.hostName = "mother";

  boot.kernel.sysctl."vm.swappiness" = 60;

  # bias latency-sensitive tasks toward P-cores; no battery to protect here
  services.scx.extraArgs = [
    "-m" "performance"
    "-P"
  ];

  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
