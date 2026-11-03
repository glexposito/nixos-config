{ lib, ... }:
{
  options.nixos.docker = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Docker container support.";
  };

  config.nixos.docker =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        docker-compose
        lazydocker
      ];
    };
}
