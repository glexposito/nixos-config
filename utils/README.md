# Utils

Personal scripts and reference configs for running things on NixOS that aren't covered by the declarative system configuration.

## Scripts

### launch-openra.sh

Launches OpenRA built from source (`~/dev/OpenRA`) on NixOS. This is only needed when building and running the game from the [OpenRA repository](https://github.com/OpenRA/OpenRA) — the Nix-packaged version (`pkgs.openraPackages.engines.release`) works out of the box.

On traditional distros (Arch, CachyOS, etc.), shared libraries live in `/usr/lib` and any app can find them. NixOS doesn't follow this convention — every package is isolated in `/nix/store/`, so apps built outside of Nix can't locate system libraries at runtime. Nix-packaged apps handle this automatically through wrappers, but dev builds don't.

OpenRA's dev build bundles its own SDL2 and OpenAL, which `dlopen` system libraries at runtime:

- **OpenGL** — `libGL.so` (libglvnd) + Mesa drivers from `/run/opengl-driver/lib` for GPU rendering
- **X11** — `libX11`, `libXcursor`, `libXrandr`, etc. for window creation via XWayland (the bundled SDL2 lacks Wayland support)
- **Audio** — `libpulse` for PulseAudio/PipeWire sound output via the bundled OpenAL
- **C++ runtime** — `libstdc++` needed by the bundled OpenAL

This script sets `LD_LIBRARY_PATH` to point at all of these in the Nix store.

```bash
# Default mod (cnc)
./utils/launch-openra.sh

# Specific mod
./utils/launch-openra.sh ra
./utils/launch-openra.sh d2k
```

## LLMs Config

### llms/llama.cpp/models.ini

Reference configuration for [llama-server](https://github.com/ggerganov/llama.cpp) with local GGUF models. Defines model paths, Vulkan GPU offloading, context sizes, and sampling parameters. See [llms/README.md](llms/README.md) for a param-by-param explanation.

Copy to `~/.config/llama.cpp/models.ini` to use.

### llms/pi/models.json

Configuration to make local llama-server models visible in [Pi](https://pi.dev/) agentic code. Points Pi at the local llama-server OpenAI-compatible endpoint (`http://localhost:8080/v1`) and registers the available models with their context windows.

Copy to `~/.pi/agent/models.json` to use.
