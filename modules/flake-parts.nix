{ inputs, ... }:
{
  # Adds the flake.modules.<class>.<name> option every other file writes into.
  imports = [ inputs.flake-parts.flakeModules.modules ];

  systems = [ "x86_64-linux" ];
}
