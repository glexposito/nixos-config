{ ... }:

{
  imports = [
    ./gnome.nix
    ./hyprland.nix
    ./mango.nix
    ./greetd.nix
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MESA_VK_IGNORE_CONFORMANCE_WARNING = "1";
  };

}
