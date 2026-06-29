{ inputs, ... }:

{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  xdg.configFile."hypr" = {
    source = "${inputs.caelestia-dots}/hypr";
    recursive = true;
  };

  programs.caelestia = {
    enable = true;
    systemd.enable = true;
    cli.enable = true;
  };
}
