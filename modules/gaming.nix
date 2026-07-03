{ pkgs, lib, config, ... }:

{
  options.profiles.gaming.enable = lib.mkEnableOption "Gaming support";

  config = lib.mkIf config.profiles.gaming.enable {
    environment.systemPackages = with pkgs; [
      openraPackages.engines.release
      beyond-all-reason
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamemode.enable = true;
  };
}
