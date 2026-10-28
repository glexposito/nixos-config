{ pkgs, lib, config, ... }:

{
  options.profiles.k3s.enable = lib.mkEnableOption "k3s Kubernetes cluster";

  config = lib.mkIf config.profiles.k3s.enable {
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
