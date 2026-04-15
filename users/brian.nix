{ 
  ...
}:

{
  imports = [ ../home.nix ];

  home = {
    username = "brian";
    homeDirectory = "/home/brian";
  };

  programs.git = {
    settings = {
      user.name = "t3rp";
      user.email = "190659213+t3rp@users.noreply.github.com";
    };
  };
}