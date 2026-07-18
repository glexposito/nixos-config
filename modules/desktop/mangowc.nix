{ pkgs, lib, config, ... }:

{
  options.profiles.mangowc.enable = lib.mkEnableOption "MangoWC desktop";

  config = lib.mkIf config.profiles.mangowc.enable {
    # nixpkgs renamed the `mangowc` package to `mango` (2026-06-23) but the
    # `programs.mangowc` module's default package option wasn't updated to match.
    programs.mangowc = {
      enable = true;
      package = pkgs.mango;
    };

    nix.settings = {
      extra-substituters = [ "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };
  };
}
