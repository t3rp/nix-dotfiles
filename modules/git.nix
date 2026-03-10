{ ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "t3rp";
      user.email = "190659213+t3rp@users.noreply.github.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
