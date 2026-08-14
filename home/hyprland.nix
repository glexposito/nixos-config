{ inputs, pkgs, lib, osConfig ? {}, ... }:
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

    home.file.".local/share/wallpapers/nix-binary-black.png".source =
      "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";

    programs.caelestia = {
      enable = true;
      systemd.enable = true;
      cli.enable = true;
    };
  };
}
