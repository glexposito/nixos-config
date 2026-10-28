{ pkgs, lib, config, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          (lib.getExe' pkgs.tuigreet "tuigreet")
          "--cmd mango"
          "--time"
          "--remember" "--remember-session"
          "--asterisks"
          "--background doom"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions"
        ];
      };
    };
  };
}
