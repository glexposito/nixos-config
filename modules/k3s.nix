{ pkgs, lib, config, ... }:

{
  options.profiles.k3s.enable = lib.mkEnableOption "k3s Kubernetes cluster";

  config = lib.mkIf config.profiles.k3s.enable {
    services.k3s = {
      enable = true;
      role = "server";
      extraFlags = [ "--write-kubeconfig-mode=644" ];
    };

    environment.systemPackages = with pkgs; [
      kubectl
      kubernetes-helm
      k9s
    ];
  };
}
