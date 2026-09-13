{ pkgs, username, ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminals.nix
    ./editors.nix
    ./file-managers.nix
    ./gnome.nix
    ./hyprland.nix
    ./mango.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.file.".local/share/wallpapers/nix-binary-black.png".source =
    "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";

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
