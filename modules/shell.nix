{ 
  config, 
  lib, 
  pkgs, 
  ... 
}:

let
  # Shell aliases
  myShellAliases = {
    hms = "nix run home-manager -- switch --impure --flake ${config.home.homeDirectory}/Development/nix-dotfiles#default";
    urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
    urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    
  };
in
{
  # Starship PS1
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };

  # Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    # Add to .bashrc
    bashrcExtra = ''
      # None
    '';
    
    # Add to .bash_profile
    profileExtra = ''
      # Nothing yet
    '';
    
    shellAliases = myShellAliases;
  };

  # ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    
    # Add to .zshrc
    initContent = ''
      # None
    '';
    
    # Add to .zprofile (login shell)
    profileExtra = ''
      # Nothing yet
    '';
    
    shellAliases = myShellAliases;
  };
}