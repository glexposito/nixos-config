{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # tools
    gnome-tweaks
    dconf-editor
    nwg-look

    # theming
    adw-gtk3
    papirus-icon-theme
    tela-icon-theme
    capitaine-cursors
    bibata-cursors
  ];
}
