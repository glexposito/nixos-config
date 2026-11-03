{ lib, ... }:
{
  options.nixos.guille = lib.mkOption {
    type = lib.types.deferredModule;
    description = "The guille account.";
  };

  config.nixos.guille =
    { config, lib, pkgs, ... }:
    {
      users.users.guille = {
        isNormalUser = true;
        description = "Guillermo";
        extraGroups = [ "networkmanager" "wheel" ]
          ++ lib.optional config.virtualisation.docker.enable "docker"
          ++ lib.optional config.programs.gamemode.enable "gamemode";
        shell = pkgs.fish;
      };

      home-manager.users.guille.programs.git.settings.user = {
        name = "Guillermo";
        email = "glexposito@gmail.com";
      };
    };
}
