{ ... }:

{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      function fish_greeting
        set_color --bold green
        echo "    SPECIAL ORDER 937"
        echo ""
        set_color green
        echo "    PRIORITY ONE"
        echo "    INSURE RETURN OF ORGANISM"
        echo "    FOR ANALYSIS."
        echo "    ALL OTHER CONSIDERATIONS SECONDARY."
        echo "    CREW EXPENDABLE."
        echo ""
        set_color normal
      end
    '';
    shellAliases = {
      cat = "bat";
      nfu = "nix flake update --flake ~/nixos-config";
      nrs-w = "sudo nixos-rebuild switch --flake ~/nixos-config#workstation";
      nrs-l = "sudo nixos-rebuild switch --flake ~/nixos-config#laptop";
      llms = "llama-server --models-preset ~/.config/llama.cpp/models.ini";
    };
  };

  programs.eza = {
    enable = true;
    icons = "auto";
    enableFishIntegration = true;
  };

  programs.starship.enable = true;
}
