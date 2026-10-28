{ pkgs, lib, config, ... }:

{
  options.profiles.docker.enable = lib.mkEnableOption "Docker container support";

  config = lib.mkIf config.profiles.docker.enable {
    virtualisation.docker.enable = true;

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
    ];
  };
}
