{ ... }:

{
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;
}
