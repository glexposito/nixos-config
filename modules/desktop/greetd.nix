{ pkgs, lib, config, ... }:

{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter";
        command = lib.concatStringsSep " " [
          (lib.getExe' pkgs.tuigreet "tuigreet")
          "--time"
          "--remember" "--remember-session"
          "--asterisks"
          "--user-menu"
          "--user-menu-min-uid 1000"
          "--user-menu-max-uid 29999"
          "--background doom"
          "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions:${config.services.displayManager.sessionData.desktops}/share/xsessions"
        ];
      };
    };
  };
}
