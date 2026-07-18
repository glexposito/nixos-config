{ inputs, pkgs, username, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminals.nix
    ./editors.nix
    ./gnome.nix
    ./hyprland.nix
    ./mangowc.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

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
