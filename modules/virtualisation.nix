{ pkgs, lib, config, ... }:

{
  options.profiles.virtualisation.enable = lib.mkEnableOption "GNOME Boxes virtual machines";

  config = lib.mkIf config.profiles.virtualisation.enable {
    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    environment.systemPackages = with pkgs; [
      gnome-boxes
    ];
  };
}
