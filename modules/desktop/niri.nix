{ pkgs, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    xwayland-satellite
    fuzzel

    wl-clipboard
    grim
    slurp
    brightnessctl
    playerctl
    pavucontrol
  ];

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
}
