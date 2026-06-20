{ pkgs, ... }:

{
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = [
    pkgs.zed-editor
    pkgs.git
    pkgs.gh
    pkgs.nodejs_24
    pkgs.rustup
    pkgs.cargo-nextest
    pkgs.python3
    pkgs.uv
    pkgs.podman-compose
    pkgs.podman-desktop
  ];
}
