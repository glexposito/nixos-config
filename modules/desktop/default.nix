{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    # apps
    discord
    google-chrome
    mission-center
    resources

    # diagnostics
    vulkan-tools
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
