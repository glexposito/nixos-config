{ pkgs, lib, config, ... }:

{
  options.modules.ai.enable = lib.mkEnableOption "AI tools";

  config = lib.mkIf config.modules.ai.enable {
    environment.systemPackages = [
      pkgs.llama-cpp-vulkan
    ];
  };
}
