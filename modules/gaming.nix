{ pkgs, lib, config, ... }:

{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming support";

  config = lib.mkIf config.profiles.gaming.enable {
    environment.systemPackages = with pkgs; [
      openraPackages.engines.release
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
