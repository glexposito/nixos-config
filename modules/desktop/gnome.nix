{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    pkgs.gnome-tweaks
    pkgs.dconf-editor
  ];
}
