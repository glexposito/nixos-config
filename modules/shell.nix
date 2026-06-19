{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.guille.shell = pkgs.fish;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = [
    pkgs.fastfetch
    pkgs.bat
    pkgs.fd
    pkgs.ripgrep
    pkgs.fzf
  ];
}
