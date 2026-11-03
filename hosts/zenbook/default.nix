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
    umbriel.enable = true;
  };

  networking.hostName = "apollo";

  monitors = [
    {
      output = "eDP-1";
      width = 2880;
      height = 1800;
      refresh = 90;
      scale = 1.25;
    }
  ];
}
