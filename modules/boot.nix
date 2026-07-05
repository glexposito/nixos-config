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

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 50;
  };
}
