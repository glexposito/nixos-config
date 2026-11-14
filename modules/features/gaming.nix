{ lib, config, ... }:
let
  hm = config.homeManager;
in
{
  options.nixos.gaming = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Gaming support.";
  };
  options.homeManager.gaming = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Home side of gaming: RetroArch.";
  };

  config.nixos.gaming =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ hm.gaming ];

      environment.systemPackages = with pkgs; [
        openraPackages.engines.release
        beyond-all-reason
      ];

      programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [ proton-ge-bin ];
      };

      programs.gamemode = {
        enable = true;
        settings.cpu.pin_cores = "no";
      };
    };

  config.homeManager.gaming =
    { pkgs, ... }:
    let
      shaders = "${pkgs.libretro-shaders-slang}/share/libretro/shaders/shaders_slang";
    in
    {
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
