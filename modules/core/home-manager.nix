{ inputs, config, ... }:
let
  hm = config.flake.modules.homeManager;
in
{
  flake.modules.nixos.core = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";
      # Every account gets the base home config; each feature adds its own
      # home half next to it (see e.g. modules/profiles/desktop/umbriel.nix).
      sharedModules = [ hm.base ];
    };
  };
}
