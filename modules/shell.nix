{ pkgs, ... }:

{
  programs.fish.enable = true;
  programs.starship.enable = true;

  users.users.guille.shell = pkgs.fish;

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    fastfetch
    eza
    bat
    fd
    ripgrep
    fzf
  ];
}
