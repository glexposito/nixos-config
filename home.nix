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
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      cat = "bat";
      nfu = "nix flake update --flake ~/nixos-config";
      nrs-w = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrs-l = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      llms = "llama-server --models-preset ~/.config/llama.cpp/models.ini";
    };
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableFishIntegration = true;
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Monokai Classic";
      background-opacity = 0.95;
      background-opacity-cells = true;
      window-padding-x = 10;
      maximize = true;
      gtk-single-instance = true;
    };
  };

  programs.foot = {
    enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.src}/themes/monokai-pro";
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:pixelsize=15";
        pad = "10x0";
        dpi-aware = "yes";
        initial-window-mode = "maximized";
      };

      scrollback = {
        indicator-position = "none";
      };

      colors-dark = {
        alpha = 0.95;
      };

      csd = {
        preferred = "none";
        size = 0;
        border-width = 0;
        hide-when-maximized = "yes";
      };
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Monokai_Classic";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      background_opacity = "0.95";
      window_padding_width = 10;
      hide_window_decorations = true;
    };
  };

  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    flavors = {
      monokai-vibrant = pkgs.fetchFromGitHub {
        owner = "sanjinso";
        repo = "monokai-vibrant.yazi";
        rev = "8b68223a8eaf014a8aac842852cc07461f07df58";
        hash = "sha256-f3IaeDJ4gZf5glk4RIVQ1/DqH0ON2Sv5UzGvdAnLEbw=";
      };
    };
    theme = {
      flavor = { use = "monokai-vibrant"; };
    };
  };

  programs.superfile = {
    enable = true;
    settings = {
      theme = "monokai";
    };
  };

  programs.starship.enable = true;

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.logo-menu; }
    ];
  };

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

  dconf.settings."org/gnome/shell/extensions/Logo-menu" = {
    menu-button-icon-image = 23;
  };

  xdg.configFile."xdg-terminals.list".text = "kitty.desktop\n";

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
    name = "Kitty";
    command = "kitty";
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
