{ inputs, pkgs, lib, config, osConfig ? {}, ... }:
{
  imports = [
    inputs.noctalia-shell.homeModules.default
  ];

  config = lib.mkIf (osConfig.profiles.mangowc.enable or false) {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      # Without an explicit wallpaper/theme, config.toml never gets written
      # (settings defaults to {}) and noctalia's built-in fallback doesn't
      # resolve to a real file, which is what renders as a plain gray screen.
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };
        wallpaper = {
          enabled = true;
          default.path = "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";
        };
      };
    };

    # mango is a bare wlroots compositor (raw ELF, no dbus-run-session wrapper,
    # never runs `systemctl --user start graphical-session.target`), so a
    # service tied to that target would never launch. Poll for the Wayland
    # socket directly instead, same workaround the labwc/noctalia post used.
    systemd.user.services.noctalia = {
      Unit = {
        After = lib.mkForce [ ];
        PartOf = lib.mkForce [ ];
      };
      Install.WantedBy = lib.mkForce [ "default.target" ];
      Service = {
        ExecStart = lib.mkForce (lib.getExe (pkgs.writeShellApplication {
          name = "noctalia-wrap";
          text = ''
            while [ ! -S "$XDG_RUNTIME_DIR/''${WAYLAND_DISPLAY:-wayland-0}" ]; do
              sleep 0.2
            done
            exec ${lib.getExe config.programs.noctalia.package}
          '';
        }));
        RestartSec = lib.mkForce 2;
      };
    };
  };
}
