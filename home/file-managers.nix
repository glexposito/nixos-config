{ ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      opener = {
        edit = [{ run = ''micro "%s"''; block = true; }];
      };
    };
  };

  programs.superfile = {
    enable = true;
    settings = {
      theme = "monokai";
    };
  };
}
