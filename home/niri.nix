{ lib, osConfig ? {}, ... }:

{
  config = lib.mkIf (osConfig.profiles.niri.enable or false) {
    programs.niri.settings = {
      outputs."DP-1" = {
        mode = {
          width = 3840;
          height = 2160;
          refresh = 240.0;
        };
        scale = 1.0;
      };
    };
  };
}
