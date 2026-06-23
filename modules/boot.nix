{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub.enable = false;

  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 10;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
