{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/ai.nix
    ../../modules/boot.nix
    ../../modules/desktop
    ../../modules/desktop/gnome.nix
    ../../modules/dev.nix
    ../../modules/dotnet.nix
    ../../modules/gaming.nix
    ../../modules/shell.nix
  ];

  networking.hostName = "nixos";

  hardware.amdgpu.initrd.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
}
