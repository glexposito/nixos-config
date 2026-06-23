{ ... }:

{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminals.nix
    ./editors.nix
    ./gnome.nix
  ];

  home.username = "guille";
  home.homeDirectory = "/home/guille";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
