{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [ "dracula" ];
    userSettings.theme = {
      mode = "dark";
      light = "Ayu Light";
      dark = "Dracula";
    };
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "dracula-tc";
      diffgutter = true;
    };
  };

  # Lets micro's external clipboard reach the Wayland system clipboard.
  home.packages = [ pkgs.wl-clipboard ];
}
