{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openraPackages.engines.release
  ];

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
}
