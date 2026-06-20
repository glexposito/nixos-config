{ pkgs, lib, config, ... }:

{
  options.profiles.podman.enable = lib.mkEnableOption "Podman container support";

  config = lib.mkIf config.profiles.podman.enable {
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = [
      pkgs.podman-compose
      pkgs.podman-desktop
    ];
  };
}
