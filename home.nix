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
      llms = "llama-server --models-preset ~/.config/llama.cpp/models.ini";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      window-padding-x = 10;
      window-padding-y = 10;
      maximize = true;
    };
  };

  programs.starship.enable = true;

  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = "Tela-grey";
    color-scheme = "prefer-dark";
  };

  dconf.settings."org/gnome/desktop/wm/keybindings" = {
    close = [ "<Super>q" ];
  };

  dconf.settings."org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"
    ];
  };

  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    name = "Ghostty";
    command = "ghostty";
    binding = "<Super>Return";
  };

  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    name = "Zed";
    command = "zeditor";
    binding = "<Super>z";
  };

  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
    name = "Browser";
    command = "firefox";
    binding = "<Super>b";
  };

  dconf.settings."org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3" = {
    name = "Files";
    command = "nautilus";
    binding = "<Super>e";
  };

  home.stateVersion = "26.05";
}
