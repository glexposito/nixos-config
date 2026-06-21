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
