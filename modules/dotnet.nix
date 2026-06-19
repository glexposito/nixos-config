{ pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.dotnetCorePackages.combinePackages [
      pkgs.dotnetCorePackages.sdk_8_0
      pkgs.dotnetCorePackages.sdk_10_0
    ])
    pkgs.dotnetCorePackages.runtime_8_0
    pkgs.dotnetCorePackages.runtime_10_0
    pkgs.dotnetCorePackages.aspnetcore_8_0
    pkgs.dotnetCorePackages.aspnetcore_10_0
  ];
}
