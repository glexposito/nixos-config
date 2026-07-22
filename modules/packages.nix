{ pkgs, username, ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override { extraPkgs = p: [ p.icu ]; };
  };

  programs.firefox.enable = true;
  programs.fish.enable = true;
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "kitty.desktop" ];
      GNOME = [ "kitty.desktop" ];
    };
  };

  users.users.${username}.shell = pkgs.fish;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # desktop
    discord
    google-chrome
    mission-center
    resources
    vulkan-tools

    # theming
    nwg-look
    adw-gtk3
    tela-icon-theme
    capitaine-cursors
    nixos-artwork.wallpapers.binary-black

    # dev
    zed-editor
    nodejs_24
    rustup
    cargo-nextest
    gnumake
    python3
    uv

    # cli tools
    btop
    fastfetch
    lm_sensors
    s-tui
  ];
}
