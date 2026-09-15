{ pkgs, username, ... }:

let
  firefoxDesktop = [ "firefox.desktop" ];
  zedDesktop = [ "dev.zed.Zed.desktop" ];
in
{
  imports = [
    ./git.nix
    ./shell.nix
    ./terminals.nix
    ./editors.nix
    ./file-managers.nix
    ./gnome.nix
    ./hyprland.nix
    ./mango.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.file.".local/share/wallpapers/nix-binary-black.png".source =
    "${pkgs.nixos-artwork.wallpapers.binary-black}/share/backgrounds/nixos/nix-wallpaper-binary-black.png";

  gtk = {
    enable = true;
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    colorScheme = "dark";
  };

  # gtk.cursorTheme only tells GTK apps which cursor to render -- it doesn't
  # export XCURSOR_THEME/XCURSOR_SIZE, which is what Wayland compositors use
  # for the actual system cursor. home.pointerCursor sets both (env vars +
  # GTK), so it applies compositor-agnostically instead of needing each
  # compositor's own mechanism (Hyprland gets this from caelestia-dots'
  # `env = XCURSOR_THEME,...` in hypr/hyprland/env.lua; mango has no
  # equivalent of its own).
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Original-Ice";
    size = 24;
    gtk.enable = true;
  };

  # home.pointerCursor only writes these into hm-session-vars.sh/.fish, which
  # a login shell sources -- but greetd launches compositors directly with no
  # shell involved, so that file never runs. systemd --user (which greetd's
  # session goes through) reads ~/.config/environment.d/*.conf regardless of
  # shell, so write it there too to actually guarantee the compositor sees it.
  xdg.configFile."environment.d/90-cursor.conf".text = ''
    XCURSOR_THEME=Bibata-Original-Ice
    XCURSOR_SIZE=24
  '';

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = firefoxDesktop;
      "application/toml" = zedDesktop;
      "application/xhtml+xml" = firefoxDesktop;
      "image/avif" = firefoxDesktop;
      "image/bmp" = firefoxDesktop;
      "image/gif" = firefoxDesktop;
      "image/jpeg" = firefoxDesktop;
      "image/png" = firefoxDesktop;
      "image/svg+xml" = firefoxDesktop;
      "image/webp" = firefoxDesktop;
      "image/x-icon" = firefoxDesktop;
      "text/html" = firefoxDesktop;
      "x-scheme-handler/http" = firefoxDesktop;
      "x-scheme-handler/https" = firefoxDesktop;
      "x-scheme-handler/discord-464069837237518357" = [
        "discord-464069837237518357.desktop"
      ];
      "x-scheme-handler/jetbrains" = [ "jetbrainsd.desktop" ];
    };
  };

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.stateVersion = "26.05";
}
