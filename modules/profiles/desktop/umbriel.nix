{ lib, inputs, config, ... }:
let
  hm = config.homeManager;
in
{
  options.nixos.umbriel = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Umbriel desktop.";
  };
  options.homeManager.umbriel = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Home side of Umbriel: compositor config and its own Noctalia profile.";
  };

  config.nixos.umbriel =
    { lib, ... }:
    {
      imports = [ inputs.umbriel.nixosModules.default ];

      home-manager.sharedModules = [ hm.umbriel ];

      programs.umbriel.enable = true;

      # Noctalia's recommended companion services.
      hardware.bluetooth.enable = lib.mkDefault true;
      services.upower.enable = lib.mkDefault true;
      services.power-profiles-daemon.enable = lib.mkDefault true;

      nix.settings = {
        extra-substituters = [ "https://umbriel.cachix.org" ];
        extra-trusted-public-keys = [
          "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
        ];
      };
    };

  config.homeManager.umbriel =
    { config, pkgs, lib, osConfig, ... }:
    let
      # Noctalia under umbriel runs as its own profile: separate config and state
      # roots (NOCTALIA_CONFIG_HOME reads $root/noctalia/), so nothing is shared
      # with mango's noctalia (modules/profiles/desktop/mango.nix) and mango's plugins don't leak in.
      noctaliaConfigHome = "${config.xdg.configHome}/noctalia-umbriel";
      noctaliaStateHome = "${config.xdg.stateHome}/noctalia-umbriel";

      noctaliaSettings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Dracula";
          # "umbriel" writes ~/.config/umbriel/noctalia.toml (included below).
          templates.builtin_ids = [
            "umbriel"
            "gtk3"
            "gtk4"
          ];
        };
        wallpaper = {
          enabled = true;
          # Absolute path: noctalia never expands "~".
          default.path = "${config.home.homeDirectory}/.local/share/wallpapers/nix-dracula.png";
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
          margin_ends = 0;
        };
        # Noctalia's icon font ships an "umbriel" glyph (U+F066).
        widget.launcher.glyph = "umbriel";
        widget.media.hide_when_no_media = true;
        dock.shadow = false;
        shell.panel.shadow = false;
      };
    in
    {
      imports = [ inputs.umbriel.homeModules.default ];

      home.packages = [ pkgs.noctalia ];

      xdg.configFile."noctalia-umbriel/noctalia/config.toml".source =
        (pkgs.formats.toml { }).generate "noctalia-umbriel-config.toml"
          noctaliaSettings;

      programs.umbriel = {
        enable = true;
        settings = {
          include = {
            # Umbriel's packaged config, as the base: its keybinds, window rules,
            # column width, etc. Like mango's source_optional=/etc/mango/config.conf,
            # only our changes go below; this file is applied last and wins.
            files = [ "${config.programs.umbriel.package}/share/umbriel/config.toml" ];
            # Dracula colours from noctalia's umbriel template. Optional so umbriel
            # still starts before noctalia first writes it.
            optional.files = [ "noctalia.toml" ];
          };

          # Umbriel runs autostart through /bin/sh -c. `noctalia msg` finds this
          # instance by WAYLAND_DISPLAY, so keybinds below need no env.
          general.autostart = [
            "NOCTALIA_CONFIG_HOME=${noctaliaConfigHome} NOCTALIA_STATE_HOME=${noctaliaStateHome} noctalia"
          ];
          # Don't open the keybind cheatsheet on every start.
          general.show_cheatsheet = false;

          # Without this umbriel picks each monitor's preferred mode (60Hz).
          output = lib.listToAttrs (
            map (m: {
              name = m.output;
              value = {
                mode = "${toString m.width}x${toString m.height}@${toString m.refresh}";
                position = [
                  0
                  0
                ];
                scale = m.scale;
              };
            }) osConfig.monitors
          );

          # Focus the window under the pointer, like mango does by default.
          input.focus.follows_mouse = true;

          # Recommended by Noctalia for umbriel (docs.noctalia.dev/noctalia/
          # compositor-settings/umbriel): rounded windows, borders, blur.
          appearance = {
            prefer_no_csd = true;
            border_width = 2;
            corner_radius = 10;
            blur = {
              enabled = true;
              optimized = true;
              passes = 2;
              radius = 3;
              noise = 0.02;
              brightness = 0.9;
              contrast = 0.9;
              saturation = 1.1;
            };
          };

          # Only our binds; the packaged ones (Mod+Q, Mod+O, ...) come from the
          # include. Mod+W and Mod+Comma are taken there, so these use free keys.
          keybinds = {
            "Mod+B" = "spawn firefox";
            "Mod+C" = "spawn zeditor";
            "Mod+E" = "spawn kitty --override font_size=16 -- superfile";
            "Mod+Shift+E" = "spawn nautilus";
            "Print" = "spawn noctalia msg screenshot-region";
            # Replaces the packaged scratchpad-toggle on this key.
            "Mod+Space" = "spawn noctalia msg panel-toggle launcher";
            "Mod+S" = "spawn noctalia msg panel-toggle control-center";
            "Mod+Shift+S" = "spawn noctalia msg settings-toggle";
            # Cycle scrolling -> dwindle -> master -> stacking on this workspace.
            "Mod+Shift+L" = "workspace-set-layout toggle";
            # Workspaces stack vertically, so Up/Down walks them.
            "Mod+Ctrl+Up" = "workspace-previous";
            "Mod+Ctrl+Down" = "workspace-next";
            # Unstack: split the focused window out of its column (stacks it if alone).
            "Mod+BracketLeft" = "window-consume-or-expel-left";
            "Mod+BracketRight" = "window-consume-or-expel-right";
            # Noctalia's window switcher, as its umbriel page recommends.
            "Alt+Tab" = "spawn noctalia msg window-switcher hold";
            "Alt+Shift+Tab" = "spawn noctalia msg window-switcher hold reverse";
          };
        };
      };
    };
}
