{ lib, config, ... }:

{
  options.profiles.hyprland.enable = lib.mkEnableOption "Hyprland desktop";

  config = lib.mkIf config.profiles.hyprland.enable {
    programs.hyprland.enable = true;

    # Hydra only caches Hyprland built with UWSM support; withUWSM = false
    # rebuilds it from source on every update. Take the cached build but
    # keep UWSM itself off.
    programs.hyprland.withUWSM = true;
    programs.uwsm.enable = lib.mkForce false;

    # caelestia's screen recorder shells out to gpu-screen-recorder, whose
    # gsr-kms-server helper needs cap_sys_admin to read the screen via KMS;
    # without this wrapper it silently fails ("Recording failed") because
    # there's no terminal/agent for the polkit prompt it falls back to.
    programs.gpu-screen-recorder.enable = true;
  };
}
