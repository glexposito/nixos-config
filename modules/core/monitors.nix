{ lib, ... }:

{
  # Set per host; home/hyprland.nix and home/mango.nix render it into each
  # compositor's own format.
  options.monitors = lib.mkOption {
    type = lib.types.listOf lib.types.attrs;
    default = [ ];
  };
}
