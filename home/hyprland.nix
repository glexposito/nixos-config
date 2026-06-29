{ inputs, lib, osConfig ? {}, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  config = lib.mkIf (osConfig.profiles.hyprland.enable or false) {
    xdg.configFile."hypr" = {
      source = "${inputs.caelestia-dots}/hypr";
      recursive = true;
    };

    xdg.configFile."caelestia/hypr-user.lua".text = builtins.readFile ../dots/caelestia/hypr-user.lua;

    xdg.configFile."caelestia/hypr-vars.lua".text = builtins.readFile ../dots/caelestia/hypr-vars.lua;

    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      cli.enable = true;
    };
  };
}
