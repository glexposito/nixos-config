{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell/v2.2.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-dots = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
    # Not following nixpkgs here: noctalia's cachix binary cache is built
    # against its own pinned nixpkgs, so following ours forces a from-source
    # rebuild of noctalia (meson/C++, sdbus-cpp, curl, libqalculate, ...).
    noctalia-shell.url = "github:noctalia-dev/noctalia";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    username = "guille";

    homeManagerModule = {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.${username} = import ./home;
      home-manager.extraSpecialArgs = { inherit inputs username; };
    };
  in {
    nixosConfigurations.zenbook = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit username; };
      modules = [
        ./hosts/zenbook
        ./configuration.nix
        inputs.noctalia-shell.nixosModules.default
        home-manager.nixosModules.home-manager
        homeManagerModule
      ];
    };

    nixosConfigurations.workstation = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit username; };
      modules = [
        ./hosts/workstation
        ./configuration.nix
        inputs.noctalia-shell.nixosModules.default
        home-manager.nixosModules.home-manager
        homeManagerModule
      ];
    };
  };
}
