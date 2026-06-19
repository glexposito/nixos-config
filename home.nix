{ pkgs, ... }:

{
  home.username = "guille";
  home.homeDirectory = "/home/guille";

  programs.git = {
    enable = true;
    settings = {
      user.name = "Guillermo";
      user.email = "glexposito@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
    };
  };

  programs.starship.enable = true;

  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = "Tela-grey";
    color-scheme = "prefer-dark";
  };

  home.stateVersion = "26.05";
}
