{ lib, ... }:
{
  options.nixos.dotnet = lib.mkOption {
    type = lib.types.deferredModule;
    description = ".NET SDK and runtimes.";
  };

  config.nixos.dotnet =
    { pkgs, ... }:
    let
      dotnet = pkgs.dotnetCorePackages;
    in
    {
      environment.systemPackages = with pkgs; [
        jetbrains.rider

        (dotnet.combinePackages [
          dotnet.sdk_8_0
          dotnet.sdk_10_0
        ])
      ];
    };
}
