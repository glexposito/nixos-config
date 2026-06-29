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

    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      cli.enable = true;
    };
  };
}
