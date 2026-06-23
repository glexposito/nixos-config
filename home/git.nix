{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Guillermo";
      user.email = "glexposito@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };
}
