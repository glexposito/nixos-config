{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      cat = "bat";
      nfu = "nix flake update --flake ~/nixos-config";
      nrs-w = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrs-z = "sudo nixos-rebuild switch --flake ~/nixos-config#zenbook";
      llms = "llama-server --models-preset ~/.config/llama.cpp/models.ini";
      ff = "fastfetch -c ${pkgs.fastfetch}/share/fastfetch/presets/examples/32.jsonc";
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "Monokai Extended";
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableFishIntegration = true;
  };

  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;

  programs.starship.enable = true;
}
