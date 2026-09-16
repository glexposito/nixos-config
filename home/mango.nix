{ inputs, config, pkgs, lib, osConfig ? {}, ... }:

{
  imports = [
    inputs.mango.hmModules.mango
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf (osConfig.profiles.mango.enable or false) {
    # Required by the "Mango Layouts" noctalia plugin (plugins.enabled below)
    # to parse `mmsg` output; without it the widget script fails silently and
    # never renders anything on the bar.
    home.packages = [ pkgs.jq ];

    # Defaults to the generic graphical-session.target, which every other
    # compositor also raises -- causing noctalia to start underneath e.g.
    # Hyprland too. Mango ships and activates its own mango-session.target
    # (mangowm/mango@e835ca0), so scope noctalia to that instead, the same
    # way hyprland.nix scopes caelestia to hyprland-session.target.
    wayland.systemd.target = "mango-session.target";

    wayland.windowManager.mango = {
      enable = true;
      systemd.enable = true;

      # The module only writes its systemd-activation script (dbus-update-
      # activation-environment, needed so xdg portals see WAYLAND_DISPLAY
      # etc.) and wires it into exec-once when autostart_sh is non-empty --
      # systemd.enable alone does not trigger it. See nix/hm-modules.nix in
      # mangowm/mango.
      autostart_sh = "true";

      # Pulls in mango's packaged default config (see modules/desktop/mango.nix)
      # before our overrides, so we keep its built-in keybinds/dispatchers
      # instead of replacing the whole config from scratch. "bind" also has
      # to land before "source": mango matches key bindings in file order and
      # stops at the first match, so our own binds must be parsed before the
      # sourced defaults to actually take priority over them (e.g. the
      # default CTRL+Left/Right tag-switch, which otherwise eats word
      # navigation in every app -- see bindp overrides below).
      topPrefixes = [ "bind" "source" ];

      settings = {
        source-optional = "/etc/mango/config.conf";

        monitorrule = [
          "name:^DP-3$,width:3840,height:2160,refresh:240,x:0,y:0,scale:1"
          "name:^eDP-1$,width:2880,height:1800,refresh:90,x:0,y:0,scale:1.25"
        ];

        env = [
          "QT_QPA_PLATFORMTHEME,gtk3"
        ];

        bind = [
          "SUPER,Return,spawn,kitty"
          "SUPER,w,spawn,firefox"
          "SUPER,c,spawn,zeditor"
          "SUPER,e,spawn,kitty --override font_size=16 -- superfile"
          "NONE,Print,spawn,noctalia msg screenshot-region"
          "SUPER,space,spawn,noctalia msg panel-toggle launcher"
          "SUPER,s,spawn,noctalia msg panel-toggle control-center"
          "SUPER,comma,spawn,noctalia msg settings-toggle"
          "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up"
          "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down"
          "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
          "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up"
          "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down"
        ];

        # `p` = pass the key through to the focused client too, so apps still
        # get Ctrl+Left/Right for word navigation instead of losing it to
        # mango's default tag-switch bind.
        bindp = [
          "CTRL,Left,spawn,true"
          "CTRL,Right,spawn,true"
        ];

        # Recommended by Noctalia: prefer its own drop shadows over mango's
        # layer-surface blur/shadows, which don't filter by surface opacity.
        blur = 1;
        blur_layer = 0;
        blur_optimized = 1;
        blur_params = {
          num_passes = 2;
          radius = 5;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.0;
        };
        layer_animations = 0;
        shadows = 1;
        layer_shadows = 0;
        shadow_only_floating = 0;
        shadows_size = 4;
        shadows_blur = 12;
        shadows_position_x = 2;
        shadows_position_y = 2;
        shadowscolor = "0x000000ff";
      };
    };

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Ayu";
        };
        wallpaper = {
          enabled = true;
          # Noctalia's docs say this should be an absolute path -- it's a
          # QML app, not a shell, so it never expands "~".
          default.path = "${config.home.homeDirectory}/.local/share/wallpapers/nix-binary-black.png";
        };
        location = {
          auto_locate = false;
          address = "Auckland, New Zealand";
        };
        weather = {
          enabled = true;
          unit = "celsius";
        };
        idle.behavior = {
          lock = {
            timeout = 600;
            action = "lock";
            enabled = true;
          };
          lock-and-suspend = {
            timeout = 900;
            action = "lock_and_suspend";
            enabled = true;
          };
        };
        bar.default = {
          shadow = false;
          contact_shadow = false;
          scale = 1.10;
          # noctalia has no "add one widget" option -- setting `start` replaces
          # the whole lane, so this reproduces its built-in default
          # (src/config/config_types.h: launcher, wallpaper, workspaces) with
          # the Mango Layouts plugin widget (see plugins.enabled below) added
          # next to workspaces. center/end are left undeclared and keep
          # noctalia's own defaults untouched.
          start = [ "launcher" "wallpaper" "workspaces" "ezequiel/mango_layouts:btn" ];
        };
        widget.launcher = {
          # Swap the default "search" glyph for the NixOS snowflake, tinted
          # like every other bar glyph instead of shown in its original colours.
          custom_image = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          custom_image_colorize = true;
        };
        widget.media.hide_when_no_media = true;
        dock.shadow = false;
        shell.panel.shadow = false;

        # "Mango Layouts" community plugin: shows/switches mango's current
        # tiling layout from a bar widget. This only enables the plugin --
        # the widget still has to be added to the bar through noctalia's own
        # Settings UI, since the bar's widget list isn't declared in Nix.
        plugins = {
          enabled = [ "ezequiel/mango_layouts" ];
          source = [
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
              enabled = true;
            }
          ];
        };
      };
    };
  };
}
