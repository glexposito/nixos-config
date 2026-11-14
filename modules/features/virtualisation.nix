{ lib, ... }:
{
  options.nixos.virtualisation = lib.mkOption {
    type = lib.types.deferredModule;
    description = "GNOME Boxes virtual machines.";
  };

  config.nixos.virtualisation =
    { pkgs, ... }:
    {
      virtualisation = {
        libvirtd.enable = true;
        spiceUSBRedirection.enable = true;
      };

      environment.systemPackages = with pkgs; [
        gnome-boxes
      ];
    };
}
