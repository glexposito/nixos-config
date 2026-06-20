{ pkgs, lib, config, ... }:

let
  dotnet = pkgs.dotnetCorePackages;
in
{
  options.profiles.dotnet.enable = lib.mkEnableOption ".NET SDK and runtimes";

  config = lib.mkIf config.profiles.dotnet.enable {
    environment.systemPackages = [
      (dotnet.combinePackages [
        dotnet.sdk_8_0
        dotnet.sdk_10_0
      ])
      dotnet.runtime_8_0
      dotnet.runtime_10_0
      dotnet.aspnetcore_8_0
      dotnet.aspnetcore_10_0
    ];
  };
}
