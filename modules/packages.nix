{ pkgs, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    # desktop
    discord
    google-chrome
    mission-center
    resources
    vulkan-tools
    nixos-artwork.wallpapers.binary-black

    # theming
    nwg-look
    adw-gtk3
    papirus-icon-theme
    tela-icon-theme
    capitaine-cursors
    bibata-cursors

    # dev
    zed-editor
    gh
    nodejs_24
    rustup
    cargo-nextest
    gnumake
    python3
    uv
  ];
}
