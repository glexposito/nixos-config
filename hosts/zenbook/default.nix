{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  profiles = {
    gnome.enable = true;
    hyprland.enable = true;
  };

  networking.hostName = "apollo";
}
