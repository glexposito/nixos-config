{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zed-editor
    git
    gh
    nodejs_24
    rustup
    cargo-nextest
    python3
    uv
  ];
}
