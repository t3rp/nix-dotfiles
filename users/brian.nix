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
    userName = "t3rp";
    userEmail = "190659213+t3rp@users.noreply.github.com";
  };
}