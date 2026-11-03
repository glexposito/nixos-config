{ lib, ... }:
{
  options.nixos.core = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Base every host gets: Nix settings, boot, networking, packages, services, graphics, greetd and Home Manager.";
  };

  config.nixos.core =
    { ... }:
    {
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
    };
}
