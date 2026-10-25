{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
    '';
    shellAliases = {
      cat = "bat";
      grep = "rg";
      nfu = "nix flake update --flake ~/nixos-config";
      nrs-w = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrs-z = "sudo nixos-rebuild switch --flake ~/nixos-config#zenbook";
      llama-serve = "llama-server --models-preset ~/.config/llama.cpp/models.ini --models-max 1";
      ff = "fastfetch -c ${pkgs.fastfetch}/share/fastfetch/presets/examples/32.jsonc";
    };
  };

  programs.bat = {
    enable = true;
    config.theme = "Dracula";
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableFishIntegration = true;
  };

  programs.fd.enable = true;
  programs.fzf.enable = true;
  programs.ripgrep.enable = true;

  programs.starship = {
    enable = true;
    presets = [ "pure-preset" ];
  };

  programs.mise = {
    enable = true;
    enableFishIntegration = true;
    globalConfig.tools = {
      terraform = "latest";
      terragrunt = "latest";
      azure-cli = "latest";
    };
  };
}
