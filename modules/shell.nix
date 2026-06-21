{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.guille.shell = pkgs.fish;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    bat
    fd
    ripgrep
    fzf
  ];
}
