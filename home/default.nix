{ inputs, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminals.nix
    ./editors.nix
    ./gnome.nix
    ./hyprland.nix
  ];

  home.username = "guille";
  home.homeDirectory = "/home/guille";

  home.packages = with pkgs; [
    papirus-icon-theme
    bibata-cursors
  ];

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
