{ pkgs, ... }:

{
  home.username = "guille";
  home.homeDirectory = "/home/guille";

  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "Guillermo";
      user.email = "glexposito@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://github.com".helper = "!/run/current-system/sw/bin/gh auth git-credential";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      cat = "bat";
      nrs-w = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrs-l = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
    };
  };

  programs.starship.enable = true;

  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = "Tela-grey";
    color-scheme = "prefer-dark";
  };

  home.stateVersion = "26.05";
}
