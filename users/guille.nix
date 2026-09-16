{ config, lib, pkgs, ... }:

{
  users.users.guille = {
    isNormalUser = true;
    description = "Guillermo";
    extraGroups = [ "networkmanager" "wheel" ]
      ++ lib.optional config.profiles.docker.enable "docker";
    shell = pkgs.fish;
  };

  home-manager.users.guille.programs.git.settings.user = {
    name = "Guillermo";
    email = "glexposito@gmail.com";
  };
}
