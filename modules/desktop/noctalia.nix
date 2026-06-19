{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    noctalia-shell
    noctalia-qs

    # Useful helpers for Noctalia / Wayland
    jq
    imagemagick
    cliphist
    wl-clipboard
  ];

  # Needed for Noctalia widgets/features
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
}
