{ lib, config, ... }:
let
  hm = config.homeManager;
in
{
  options.nixos.llm = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Local LLM inference: llama.cpp (Vulkan).";
  };
  options.homeManager.llm = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Home side of LLM: llama.cpp and Pi model configs.";
  };

  config.nixos.llm =
    { pkgs, ... }:
    {
      home-manager.sharedModules = [ hm.llm ];

      environment.systemPackages = with pkgs; [
        llama-cpp-vulkan
      ];
    };

  # Out-of-store symlinks into the repo, so edits apply without a rebuild.
  config.homeManager.llm =
    { config, ... }:
    let
      link = file:
        config.lib.file.mkOutOfStoreSymlink
          "${config.home.homeDirectory}/nixos-config/modules/features/llm/${file}";
    in
    {
      xdg.configFile."llama.cpp/models.ini".source = link "models.ini";
      home.file.".pi/agent/models.json".source = link "pi-models.json";
    };
}
