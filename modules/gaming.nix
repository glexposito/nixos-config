{ pkgs, lib, config, ... }:

{
  options.modules.gaming.enable = lib.mkEnableOption "gaming support";

  config = lib.mkIf config.modules.gaming.enable {
    environment.systemPackages = [
      pkgs.openraPackages.engines.release
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;
  };
}
