{ lib, config, ... }:

{
  options.profiles.hyprland.enable = lib.mkEnableOption "Hyprland desktop";

  config = lib.mkIf config.profiles.hyprland.enable {
    programs.hyprland.enable = true;
  };
}
