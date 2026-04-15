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
    user.name = "t3rp";
    user.email = "190659213+t3rp@users.noreply.github.com";
  };
}