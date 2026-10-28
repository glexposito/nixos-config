{ ... }:

{
  imports = [
    ./modules/core
    ./modules/profiles
    ./users/guille.nix
  ];

  time.timeZone = "Pacific/Auckland";
  i18n.defaultLocale = "en_NZ.UTF-8";

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  nix.optimise.automatic = true;

  zramSwap.enable = true;

  system.stateVersion = "26.05";
}
