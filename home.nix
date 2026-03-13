{ config, pkgs, username, homeDirectory, ... }:

{
  # Home Manager Variables
  home = {
    username = username;
    homeDirectory = homeDirectory;
    stateVersion = "26.05";

    # Gnome Fix
    sessionVariables = {
      # XDG_DATA_DIRS tells applications (including GNOME) where to find data files
      # This includes .desktop files for application discovery
      # Prepend the Home Manager profile path and preserve existing system paths.
      # If unset, fall back to common distro defaults plus snapd desktop entries.
      XDG_DATA_DIRS = "${config.home.profileDirectory}/share\${XDG_DATA_DIRS:+:\${XDG_DATA_DIRS}}";
    };
  };

  # Modules
  imports = [
    ./modules
  ];

  # Manage
  programs.home-manager.enable = true;
}
