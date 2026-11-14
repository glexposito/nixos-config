{ lib, ... }:
{
  options.nixos.k3s = lib.mkOption {
    type = lib.types.deferredModule;
    description = "k3s Kubernetes cluster.";
  };

  config.nixos.k3s =
    { pkgs, lib, ... }:
    {
      services.k3s = {
        enable = true;
        role = "server";
        extraFlags = [ "--write-kubeconfig-mode=644" ];
      };

      # Installed but not auto-started at boot; start on demand with
      # `systemctl start k3s` (and `systemctl stop k3s` when done).
      systemd.services.k3s.wantedBy = lib.mkForce [ ];

      environment.systemPackages = with pkgs; [
        kubectl
        kubernetes-helm
        k9s
      ];
    };
}
