{ config, pkgs, ... }:

{
  # Home Manager Variables
  home = {
    username = "terp";
    homeDirectory = "/home/terp";
    stateVersion = "24.11";

    # Gnome Fix
    sessionVariables = {
      # XDG_DATA_DIRS tells applications (including GNOME) where to find data files
      # This includes .desktop files for application discovery
      # We add the Nix-managed directories so GNOME can find our Nix programs
      XDG_DATA_DIRS = "${config.home.homeDirectory}/.nix-profile/share:/usr/local/share:/usr/share";
    };
  };

  # Modules
  imports = [
    ./modules
  ];

  # Manage
  programs.home-manager.enable = true;
}
