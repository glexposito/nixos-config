{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (with dotnetCorePackages; combinePackages [
      sdk_8_0
      sdk_10_0
    ])
    dotnetCorePackages.runtime_8_0
    dotnetCorePackages.runtime_10_0
    dotnetCorePackages.aspnetcore_8_0
    dotnetCorePackages.aspnetcore_10_0
  ];
}
