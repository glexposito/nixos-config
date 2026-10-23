{ inputs, lib, pkgs, osConfig ? {}, ... }:
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

    home.file.".local/share/wallpapers/caelestia.webp".source =
      "${inputs.caelestia-shell}/assets/wallpaper.webp";

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
      # caelestia-cli otherwise writes Papirus-{Dark,Light} (not installed) as
      # the GTK/Qt icon theme whenever it applies a scheme; match gtk.iconTheme.
      cli.settings.theme.iconTheme = "Tela-dracula-dark";
      # Tela's nix-snowflake sits on a round badge, which caelestia tints into
      # a solid disc with a tiny logo (caelestia-dots/shell#416). Use the plain
      # snowflake instead, same as mango's launcher button.
      settings.general.logo = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    };
  };
}
