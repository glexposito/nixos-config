{ pkgs, ... }:

{
  users.users.sol = {
    isNormalUser = true;
    description = "Sol";
    extraGroups = [ "networkmanager" ];
    shell = pkgs.fish;
  };

  home-manager.users.sol.programs.git.settings.user = {
    name = "Sol";
    email = "sol@apollo.local";
  };
}
