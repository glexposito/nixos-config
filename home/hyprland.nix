{ inputs, lib, pkgs, osConfig ? {}, ... }:
{
  imports = [
    inputs.caelestia-shell.homeManagerModules.default
  ];

  # osConfig is injected by home-manager's NixOS integration; outside it (e.g. standalone
  # home-manager) osConfig is {}, profiles.hyprland.enable is missing, and this block is skipped.
  config = lib.mkIf (osConfig.profiles.hyprland.enable or false) {
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
      # Both come from programs.hyprland in modules/desktop/hyprland.nix.
      package = null;
      portalPackage = null;
      # Hyprland already raises hyprland-session.target itself (see
      # programs.caelestia.systemd.target below).
      systemd.enable = false;

      settings = {
        # Locals render at the very top of hyprland.lua, so caelestia's
        # defaults load before the overrides below (e.g. its env.lua sets
        # QT_QPA_PLATFORMTHEME=qtengine, which ours has to come after).
        caelestia._var = lib.generators.mkLuaInline ''dofile("${inputs.caelestia-dots}/hypr/hyprland.lua")'';

        monitor = [
          {
            output = "DP-3";
            mode = "3840x2160@240";
            scale = 1;
          }
          {
            output = "eDP-1";
            mode = "2880x1800@90";
            scale = 1.25;
          }
        ];

        env._args = [
          "QT_QPA_PLATFORMTHEME"
          "gtk3"
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
      systemd.enable = true;
      # Defaults to the generic graphical-session.target, which mango (and
      # any other compositor) also raises -- causing caelestia's shell to
      # start underneath mango too. Hyprland creates its own
      # hyprland-session.target transiently at startup (built in since
      # https://wiki.hypr.land/Useful-Utilities/Systemd-start/), so scope
      # caelestia to that instead.
      systemd.target = "hyprland-session.target";
      cli.enable = true;
      # caelestia-cli otherwise writes Papirus-{Dark,Light} (not installed) as
      # the GTK/Qt icon theme whenever it applies a scheme; match gtk.iconTheme.
      cli.settings.theme.iconTheme = "Tela-dracula-dark";
      # Tela's nix-snowflake sits on a round badge, which caelestia tints into
      # a solid disc with a tiny logo (caelestia-dots/shell#416). Use the plain
      # snowflake instead, same as mango's launcher button.
      settings.general.logo = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
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
