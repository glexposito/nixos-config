{
  flake.modules.nixos.docker =
    { pkgs, ... }:
    {
      virtualisation.docker.enable = true;

      environment.systemPackages = with pkgs; [
        docker-compose
        lazydocker
      ];
    };
}
