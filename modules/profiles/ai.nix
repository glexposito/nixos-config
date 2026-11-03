{ lib, ... }:
{
  options.nixos.ai = lib.mkOption {
    type = lib.types.deferredModule;
    description = "AI tools.";
  };

  config.nixos.ai =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        llama-cpp-vulkan
      ];
    };
}
