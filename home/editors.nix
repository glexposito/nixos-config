{ ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    flavors = {};
    theme = {};
    settings = {
      opener = {
        edit = [{ run = ''micro "$@"''; block = true; }];
      };
    };
  };

  programs.superfile = {
    enable = true;
    settings = {
      theme = "monokai";
    };
  };

  programs.micro = {
    enable = true;
    settings = {
      colorscheme = "monokai-dark";
      diffgutter = true;
    };
  };
}
