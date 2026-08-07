{ pkgs, lib, config, username, ... }:

{
  options.profiles.docker.enable = lib.mkEnableOption "Docker container support";

  config = lib.mkIf config.profiles.docker.enable {
    virtualisation.docker.enable = true;

    users.users.${username}.extraGroups = [ "docker" ];

    environment.systemPackages = with pkgs; [
      docker-compose
      lazydocker
    ];
  };
}
