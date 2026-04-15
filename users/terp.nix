{ 
  ... 
}:

{
  imports = [ ../home.nix ];

  home = {
    username = "terp";
    homeDirectory = "/home/terp";
  };

  programs.git = {
    userName = "t3rp";
    userEmail = "190659213+t3rp@users.noreply.github.com";
  };
}