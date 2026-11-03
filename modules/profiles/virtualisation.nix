{
  flake.modules.nixos.virtualisation =
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
