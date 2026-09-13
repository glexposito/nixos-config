{ inputs, lib, osConfig ? {}, ... }:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  # osConfig is injected by home-manager's NixOS integration; outside it (e.g. standalone
  # home-manager) osConfig is {}, profiles.hyprland.enable is missing, and this block is skipped.
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
      # Defaults to the generic graphical-session.target, which mango (and
      # any other compositor) also raises -- causing caelestia's shell to
      # start underneath mango too. Hyprland creates its own
      # hyprland-session.target transiently at startup (built in since
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/), so scope
      # caelestia to that instead.
      systemd.target = "hyprland-session.target";
      cli.enable = true;
    };
  };
}
