{ pkgs, ... }:

let
  dotnet = pkgs.dotnetCorePackages;
in
{
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
}
