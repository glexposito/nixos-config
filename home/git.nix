{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Guillermo";
      user.email = "glexposito@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };
}
