{ inputs, pkgs, ... }:

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
    package = inputs.superfile.packages.${pkgs.stdenv.hostPlatform.system}.default;
    settings = {
      editor = "hx";
      theme = "dracula";
      ignore_missing_fields = true;
    };
  };
}
