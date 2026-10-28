{ pkgs, lib, config, ... }:

{
  options.profiles.gnome.enable = lib.mkEnableOption "GNOME desktop";

  config = lib.mkIf config.profiles.gnome.enable {
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      dconf-editor
    ];
  };
}
