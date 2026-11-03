{
  flake.modules.homeManager.base =
    { ... }:
    {
      # Each account's Git identity is configured in modules/users/<name>.nix.
      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
          pull.rebase = true;
        };
      };

      programs.gh = {
        enable = true;
        settings.git_protocol = "https";
      };

      programs.lazygit.enable = true;
    };
}
