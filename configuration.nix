{ ... }:

{
  imports = [
    ./modules/ai.nix
    ./modules/boot.nix
    ./modules/desktop
    ./modules/docker.nix
    ./modules/dotnet.nix
    ./modules/gaming.nix
    ./modules/k3s.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/podman.nix
    ./modules/services.nix
    ./modules/virtualisation.nix
    ./users/guille.nix
  ];

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Prebuilt noctalia binaries, published by noctalia's own CI.
  nix.settings.extra-substituters = [ "https://noctalia.cachix.org" ];
  nix.settings.extra-trusted-public-keys = [
    "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  nix.optimise.automatic = true;

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
