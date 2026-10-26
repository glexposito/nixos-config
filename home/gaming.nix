{ lib, pkgs, osConfig ? {}, ... }:
let
  shaders = "${pkgs.libretro-shaders-slang}/share/libretro/shaders/shaders_slang";
in
{
  # osConfig is injected by home-manager's NixOS integration; outside it (e.g. standalone
  # home-manager) osConfig is {}, profiles.gaming.enable is missing, and this block is skipped.
  config = lib.mkIf (osConfig.profiles.gaming.enable or false) {
    programs.retroarch = {
      enable = true;
      cores.fbneo.enable = true;
      # Passed via --appendconfig, so ~/.config/retroarch/retroarch.cfg stays writable.
      settings = {
        video_driver = "vulkan";
        video_shader_dir = shaders;
        video_shader_enable = "true";
      };
    };

    # Core-specific auto preset: RetroArch loads it for every FBNeo game unless a
    # game- or folder-specific preset exists in the same directory.
    xdg.configFile."retroarch/config/FinalBurn Neo/FinalBurn Neo.slangp".text = ''
      #reference "${shaders}/crt/crt-guest-advanced.slangp"
    '';
  };
}
