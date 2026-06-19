{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  environment.systemPackages = [
    # tools
    pkgs.gnome-tweaks
    pkgs.dconf-editor
    pkgs.nwg-look

    # theming
    pkgs.adw-gtk3
    pkgs.papirus-icon-theme
    pkgs.tela-icon-theme
    pkgs.capitaine-cursors
    pkgs.bibata-cursors
  ];
}
