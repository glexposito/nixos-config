{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.openraPackages.engines.release
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
}
