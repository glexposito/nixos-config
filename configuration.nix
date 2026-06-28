{ pkgs, ... }:

{
  imports = [
    ./modules/ai.nix
    ./modules/boot.nix
    ./modules/desktop
    ./modules/dotnet.nix
    ./modules/gaming.nix
    ./modules/networking.nix
    ./modules/packages.nix
    ./modules/podman.nix
    ./modules/services.nix
  ];

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";

  users.users.guille = {
    isNormalUser = true;
    description = "Guillermo";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
    pkgs.openssl
  ];

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
