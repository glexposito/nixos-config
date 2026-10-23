{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../users/sol.nix
  ];

  profiles = {
    gnome.enable = true;
    hyprland.enable = true;
    mango.enable = true;
  };

  networking.hostName = "apollo";
}
