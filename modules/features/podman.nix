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
        containers = {
          enable = true;
          registries.settings.unqualified-search-registries = [ "docker.io" ];
          # podman-tui only connects through podman's connection list
          containersConf.settings.engine = {
            active_service = "local";
            service_destinations.local.uri = "unix:///run/user/1000/podman/podman.sock";
          };
        };
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      # Rootless API socket for every user (podman-tui, lazydocker, Podman Desktop)
      systemd.user.sockets.podman.wantedBy = [ "sockets.target" ];

      # lazydocker reads DOCKER_HOST; point it at the rootless socket
      programs.fish.interactiveShellInit = ''
        set -gx DOCKER_HOST unix://$XDG_RUNTIME_DIR/podman/podman.sock
      '';

      environment.systemPackages = with pkgs; [
        docker-compose
        podman-desktop
        podman-tui
        lazydocker
      ];
    };
}
