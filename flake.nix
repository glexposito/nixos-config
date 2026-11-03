{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    # Imports every .nix file under ./modules (paths containing /_ are skipped).
    import-tree.url = "github:denful/import-tree";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Top-level so `nix flake update` moves them with nixpkgs; otherwise they
    # stay frozen at whatever caelestia-shell's tagged flake.lock pins.
    caelestia-cli = {
      url = "github:caelestia-dots/cli";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.caelestia-shell.follows = "caelestia-shell";
    };
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    caelestia-shell = {
      url = "github:caelestia-dots/shell/v2.5.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.caelestia-cli.follows = "caelestia-cli";
      inputs.quickshell.follows = "quickshell";
    };
    caelestia-dots = {
      url = "github:caelestia-dots/caelestia";
      flake = false;
    };
    mango = {
      url = "github:mangowm/mango/0.18.4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # No nixpkgs follows: it would miss umbriel.cachix.org. The cachix branch
    # only tracks commits whose binaries are already in that cache.
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
