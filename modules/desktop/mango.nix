{ inputs, lib, config, ... }:

{
  imports = [ inputs.mango.nixosModules.mango ];

  options.profiles.mango.enable = lib.mkEnableOption "Mango (mangowc) desktop";

  config = lib.mkIf config.profiles.mango.enable {
    programs.mango = {
      enable = true;
      addLoginEntry = true;
    };

    # mango's fallback config path is compiled in as the literal string "/etc",
    # not the package's own $out/etc, so its packaged default config.conf has to
    # be placed at the real /etc/mango/config.conf by hand for the home-manager
    # config's `source-optional=/etc/mango/config.conf` to find it.
    environment.etc."mango/config.conf".source =
      "${config.programs.mango.package}/etc/mango/config.conf";

    # Noctalia's recommended companion services.
    hardware.bluetooth.enable = lib.mkDefault true;
    services.upower.enable = lib.mkDefault true;
    services.power-profiles-daemon.enable = lib.mkDefault true;
  };
}
