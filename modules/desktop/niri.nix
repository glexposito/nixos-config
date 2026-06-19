{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = [
    pkgs.xwayland-satellite
    pkgs.fuzzel

    pkgs.wl-clipboard
    pkgs.grim
    pkgs.slurp
    pkgs.brightnessctl
    pkgs.playerctl
    pkgs.pavucontrol
  ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
}
