{ lib, inputs, config, ... }:
let
  hm = config.homeManager;
in
{
  options.nixos.hyprland = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Hyprland desktop.";
  };
  options.homeManager.hyprland = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Home side of Hyprland: Caelestia Shell and dots.";
  };

  config.nixos.hyprland =
    { lib, ... }:
    {
      home-manager.sharedModules = [ hm.hyprland ];

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

  config.homeManager.hyprland =
    { lib, osConfig, ... }:
    {
      imports = [
        inputs.caelestia-shell.homeManagerModules.default
      ];

      # Everything from caelestia-dots' hypr/ except hyprland.lua, which the
      # hyprland module below generates instead (and dofile()s caelestia's).
      xdg.configFile = {
        "hypr/hyprland" = {
          source = "${inputs.caelestia-dots}/hypr/hyprland";
          recursive = true;
        };
        "hypr/utils" = {
          source = "${inputs.caelestia-dots}/hypr/utils";
          recursive = true;
        };
        "hypr/variables.lua".source = "${inputs.caelestia-dots}/hypr/variables.lua";
        # Linked as a single file so scheme/ stays writable: caelestia writes
        # scheme/current.lua next to it at runtime.
        "hypr/scheme/default.lua".source = "${inputs.caelestia-dots}/hypr/scheme/default.lua";

        # Overrides for caelestia-dots' variables.lua (used by its keybinds,
        # env and rules), merged in by its hyprland.lua before loading them.
        "caelestia/hypr-vars.lua".text = "return ${lib.generators.toLua { } {
          terminal = "kitty";
          kbTerminal = [
            "SUPER + T" # caelestia's default
            "SUPER + Return"
          ];
          cursorTheme = "Bibata-Original-Ice";
          editor = "zeditor";
          fileExplorer = "kitty --override font_size=16 -- superfile";
        }}\n";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        # Both come from programs.hyprland in modules/profiles/desktop/hyprland.nix.
        package = null;
        portalPackage = null;
        # systemd.enable (default true) creates hyprland-session.target, bound to
        # graphical-session.target, and starts it on hyprland.start. Hyprland
        # does not do this itself; without it xdg-desktop-portal (Requisite=
        # graphical-session.target) never starts.

        settings = {
          # Locals render at the very top of hyprland.lua, so caelestia's
          # defaults load before the overrides below (e.g. its env.lua sets
          # QT_QPA_PLATFORMTHEME=qtengine, which ours has to come after).
          caelestia._var = lib.generators.mkLuaInline ''dofile("${inputs.caelestia-dots}/hypr/hyprland.lua")'';

          monitor = map (m: {
            inherit (m) output scale;
            mode = "${toString m.width}x${toString m.height}@${toString m.refresh}";
          }) osConfig.monitors;

          env._args = [
            "QT_QPA_PLATFORMTHEME"
            "gtk3"
          ];

          bind._args = [
            "SUPER + SHIFT + E"
            (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("nautilus")'')
          ];

          on._args = [
            "hyprland.start"
            (lib.generators.mkLuaInline ''
              function()
                hl.exec_cmd("caelestia scheme set -n dracula && caelestia wallpaper -f ~/.local/share/wallpapers/caelestia.webp")
              end'')
          ];
        };
      };

      home.file.".local/share/wallpapers/caelestia.webp".source =
        "${inputs.caelestia-shell}/assets/wallpaper.webp";

      programs.caelestia = {
        enable = true;
        # caelestia-dots' execs.lua already starts the shell on hyprland.start
        # (`caelestia shell -d`, which passes quickshell's --no-duplicate). The
        # service runs quickshell without it, so enabling both spawns two bars.
        systemd.enable = false;
        cli.enable = true;
        # caelestia-cli otherwise writes Papirus-{Dark,Light} (not installed) as
        # the GTK/Qt icon theme whenever it applies a scheme; match gtk.iconTheme.
        cli.settings.theme.iconTheme = "Tela-dracula-dark";
        # Unset falls back to the os-release logo, Tela's badged nix-snowflake,
        # which caelestia tints into a solid disc (caelestia-dots/shell#416).
        settings.general.logo = "caelestia";
        # Replaces caelestia's whole default list (lock 3m, screen off 5m,
        # suspend 10m), so the screen-off step has to be restated too.
        settings.general.idle.timeouts = [
          {
            timeout = 600;
            idleAction = "lock";
          }
          {
            timeout = 720;
            idleAction = "dpms off";
            returnAction = "dpms on";
          }
          {
            timeout = 900;
            idleAction = [ "suspendThenHibernate" ];
          }
        ];
      };
    };
}
