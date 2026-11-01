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
    mango.enable = true;
  };

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
