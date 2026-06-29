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

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Ice";
    };
    colorScheme = "dark";
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
