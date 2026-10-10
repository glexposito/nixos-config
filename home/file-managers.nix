{ ... }:

{
  programs.yazi = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      opener = {
        edit = [
          {
            run = ''micro "%s"'';
            block = true;
          }
        ];
      };
    };
  };

  programs.superfile = {
    enable = true;
    settings = {
      editor = "hx";
      theme = "dracula";
      ignore_missing_fields = true;
    };
  };
}
