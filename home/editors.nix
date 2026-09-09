{ pkgs, ... }:

{
  home.packages = [ pkgs.zed-editor ];

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "monokai-dark";
      diffgutter = true;
    };
  };
}
