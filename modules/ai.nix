{ pkgs, lib, config, ... }:

{
  options.profiles.ai.enable = lib.mkEnableOption "AI tools";

  config = lib.mkIf config.profiles.ai.enable {
    environment.systemPackages = [
      pkgs.llama-cpp-vulkan
    ];
  };
}
