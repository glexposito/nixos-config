{
  flake.modules.nixos.core =
    { lib, ... }:
    {
      # Set per host; the hyprland, mango and umbriel home configs render it into each
      # compositor's own format.
      options.monitors = lib.mkOption {
        type = lib.types.listOf lib.types.attrs;
        default = [ ];
      };
    };
}
