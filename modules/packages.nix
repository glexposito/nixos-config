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
    terraform
    (terragrunt.overrideAttrs (
      finalAttrs: _prevAttrs: {
        version = "1.1.3";
        src = pkgs.fetchFromGitHub {
          owner = "gruntwork-io";
          repo = "terragrunt";
          tag = "v${finalAttrs.version}";
          hash = "sha256-JovTD88P/9IUX1y1AG/NhkIRRPCa0eAwJSx5qfg+4Ck=";
        };
        vendorHash = "sha256-eqoT9On/nGwJIbWug4RQVmibbsqbTRa5MzOoFXgGmxc=";
        ldflags = [
          "-s"
          "-X github.com/gruntwork-io/terragrunt/internal/version.Version=v${finalAttrs.version}"
          "-extldflags '-static'"
        ];
      }
    ))
    azure-cli

    # cli tools
    btop
    fastfetch
    lm_sensors
    s-tui
  ];
}
