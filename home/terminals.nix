{ pkgs, ... }:

{
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
    themeFile = "Monokai_Soda";
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
}
