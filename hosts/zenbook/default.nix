{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  profiles.gnome.enable = true;

  networking.hostName = "apollo";
}
