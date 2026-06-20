{ pkgs, ... }:

{
  programs.firefox.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = [
    # apps
    pkgs.discord
    pkgs.ghostty
    pkgs.google-chrome
    pkgs.mission-center
    pkgs.resources

    # diagnostics
    pkgs.vulkan-tools

    # wallpapers
    pkgs.nixos-artwork.wallpapers.binary-black
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
