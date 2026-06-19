{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/desktop
    ../../modules/desktop/gnome.nix
    ../../modules/dev.nix
    ../../modules/shell.nix
  ];

  networking.hostName = "nixos";
}
