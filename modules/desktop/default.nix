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
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
