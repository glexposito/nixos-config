{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.fish.enable = true;

  users.users.guille.shell = pkgs.fish;

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
    xdg-terminal-exec

    # theming
    nwg-look
    adw-gtk3
    papirus-icon-theme
    tela-icon-theme
    capitaine-cursors
    bibata-cursors
    nixos-artwork.wallpapers.binary-black

    # dev
    zed-editor
    gh
    nodejs_24
    rustup
    cargo-nextest
    gnumake
    python3
    uv

    # cli tools
    fastfetch
    bat
    fd
    ripgrep
    fzf
  ];
}
