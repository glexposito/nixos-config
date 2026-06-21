{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.zed-editor
    pkgs.git
    pkgs.gh
    pkgs.nodejs_24
    pkgs.rustup
    pkgs.cargo-nextest
    pkgs.gnumake
    pkgs.python3
    pkgs.uv
  ];
}
