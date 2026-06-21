#!/usr/bin/env bash
export LD_LIBRARY_PATH=/run/opengl-driver/lib:$(nix eval --raw nixpkgs#libglvnd)/lib:$(nix eval --raw nixpkgs#stdenv.cc.cc.lib)/lib:$(nix eval --raw nixpkgs#xorg.libX11)/lib:$(nix eval --raw nixpkgs#xorg.libXcursor)/lib:$(nix eval --raw nixpkgs#xorg.libXrandr)/lib:$(nix eval --raw nixpkgs#xorg.libXi)/lib:$(nix eval --raw nixpkgs#xorg.libXext)/lib:$(nix eval --raw nixpkgs#xorg.libXfixes)/lib:$(nix eval --raw nixpkgs#libpulseaudio)/lib
exec "$HOME/dev/OpenRA/launch-game.sh" Game.Mod="${1:-cnc}" Graphics.Mode=Fullscreen
