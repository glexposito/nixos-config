{ inputs, lib, config, ... }:

{
  imports = [ inputs.umbriel.nixosModules.default ];

  options.profiles.umbriel.enable = lib.mkEnableOption "Umbriel desktop";

  config = lib.mkIf config.profiles.umbriel.enable {
    programs.umbriel.enable = true;

    # Noctalia's recommended companion services.
    hardware.bluetooth.enable = lib.mkDefault true;
    services.upower.enable = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault true;

    nix.settings = {
      extra-substituters = [ "https://umbriel.cachix.org" ];
      extra-trusted-public-keys = [
        "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
      ];
    };
  };
}
