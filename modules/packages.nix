{ pkgs, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = [
    # desktop
    pkgs.discord
    pkgs.google-chrome
    pkgs.mission-center
    pkgs.resources
    pkgs.vulkan-tools
    pkgs.nixos-artwork.wallpapers.binary-black

    # theming
    pkgs.nwg-look
    pkgs.adw-gtk3
    pkgs.papirus-icon-theme
    pkgs.tela-icon-theme
    pkgs.capitaine-cursors
    pkgs.bibata-cursors

    # dev
    pkgs.zed-editor
    pkgs.gh
    pkgs.nodejs_24
    pkgs.rustup
    pkgs.cargo-nextest
    pkgs.gnumake
    pkgs.python3
    pkgs.uv
  ];
}
