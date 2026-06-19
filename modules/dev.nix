{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    git
    nodejs_24
    rustup
    cargo-nextest
    python3
    uv
  ];
}
