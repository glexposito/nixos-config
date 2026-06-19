{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.noctalia-shell
    pkgs.noctalia-qs

    # Useful helpers for Noctalia / Wayland
    pkgs.jq
    pkgs.imagemagick
    pkgs.cliphist
    pkgs.wl-clipboard
  ];

  # Needed for Noctalia widgets/features
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
