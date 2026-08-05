final: prev:
let
  # Hyprland 0.56.1 requires glaze in the 7.x range (find_package(glaze 7...<8)),
  # but nixpkgs bumped the standalone glaze package to 8.0.0, breaking the build
  # (CMake falls back to a network FetchContent that fails in the sandbox).
  # Give only Hyprland the last 7.x release until nixpkgs/Hyprland reconcile.
  glaze7 = prev.glaze.overrideAttrs (old: rec {
    version = "7.9.1";
    src = prev.fetchFromGitHub {
      owner = "stephenberry";
      repo = "glaze";
      tag = "v${version}";
      hash = "sha256-NRRq5MGF2f5PW0teYnq58ELzson+U6KHVPaY6r30KLA=";
    };
  });
in
{
  hyprland = prev.hyprland.override { glaze = glaze7; };
}
