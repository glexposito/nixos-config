{ lib, ... }:
{
  options.nixos.podman = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Podman container support.";
  };

  config.nixos.podman =
    { pkgs, ... }:
    {
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      environment.systemPackages = with pkgs; [
        podman-compose
        podman-desktop
        lazydocker
      ];
    };
}
