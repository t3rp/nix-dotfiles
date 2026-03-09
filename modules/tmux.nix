{ config, pkgs, ... }:

{
  # Enable and configure tmux - a terminal multiplexer that allows
  # multiple terminal sessions in a single window with panes and windows
  programs.tmux = {
    # Enable tmux installation and configuration via Home Manager
    enable = true;

    # The prefix is the key combination that activates tmux commands
    # Default is Ctrl+b, but Ctrl+a is popular (easier to reach)
    # Set to null to keep the default Ctrl+b
    prefix = "C-a"; # Ctrl+a as prefix (more ergonomic than default Ctrl+b)

    # Enable mouse support - allows clicking to select panes, resize, scroll, etc.
    # Very useful for beginners and when using a GUI terminal
    mouse = true;

    # Set the base index for windows to 1 instead of 0
    # Makes it easier to switch windows since 1 is closer to the other numbers
    baseIndex = 1;

    # Terminal type - tells programs what features your terminal supports
    # "screen-256color" provides 256 color support which makes vim/neovim look better
    terminal = "screen-256color";

    # Clock mode settings - shown when you press prefix + t
    # 24 hour format is clearer than 12 hour for most users
    clock24 = true;

    # Escape time is the delay tmux waits to see if ESC is part of a key sequence
    # Default is 500ms which feels sluggish, especially in vim/neovim
    # Setting to 0 makes ESC key respond instantly
    escapeTime = 0;

    # History limit - how many lines of scrollback to keep per pane
    # 10000 is a good balance between memory usage and having enough history
    historyLimit = 10000;

    # Key bindings mode - determines which key bindings to use for copy mode
    # "vi" uses vim-style keys (more powerful and consistent with vim)
    # "emacs" is the default
    keyMode = "vi";

    # Additional custom configuration that doesn't have dedicated options
    # This allows us to add any tmux settings using raw tmux.conf syntax
    extraConfig = ''
      # ============================================================================
      # Key Bindings
      # ============================================================================
      
      # Vim-style pane navigation - use hjkl to move between panes
      # This is more intuitive if you use vim/neovim
      # prefix + h/j/k/l moves left/down/up/right between panes
      bind h select-pane -L  # Move to pane on the left
      bind j select-pane -D  # Move to pane below
      bind k select-pane -U  # Move to pane above
      bind l select-pane -R  # Move to pane on the right

      # Vim-style pane resizing - use Shift+hjkl to resize panes
      # Capital letters (with Shift) make panes bigger/smaller
      bind -r H resize-pane -L 5  # Resize pane left by 5 cells
      bind -r J resize-pane -D 5  # Resize pane down by 5 cells
      bind -r K resize-pane -U 5  # Resize pane up by 5 cells
      bind -r L resize-pane -R 5  # Resize pane right by 5 cells

      # Split panes more intuitively
      # | splits vertically (creates a vertical line between panes)
      # - splits horizontally (creates a horizontal line between panes)
      bind | split-window -h -c "#{pane_current_path}"  # Split vertically, keep current path
      bind - split-window -v -c "#{pane_current_path}"  # Split horizontally, keep current path

      # Easier reload of tmux config
      # prefix + r reloads the tmux configuration file
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # ============================================================================
      # Visual Customization
      # ============================================================================

      # Enable true color support - makes colors look much better in vim/neovim
      set -ga terminal-overrides ",*256col*:Tc"

      # Status bar position - top or bottom of screen
      set -g status-position bottom

      # Status bar update interval in seconds
      set -g status-interval 1

      # Status bar colors and style
      set -g status-style fg=white,bg=black

      # Left side of status bar
      # Shows [session name] in green
      set -g status-left-length 40
      set -g status-left "#[fg=green,bold][#S] "

      # Right side of status bar
      # Shows current time and date
      set -g status-right "#[fg=cyan]%H:%M #[fg=yellow]%d-%b-%Y"

      # Window list in center of status bar
      # Current window is highlighted in green
      set -g window-status-current-style fg=green,bold
      set -g window-status-style fg=white,dim

      # Window status format - how each window appears in the status bar
      # Shows window number and window name
      set -g window-status-format " #I:#W "
      set -g window-status-current-format " #I:#W "

      # Pane border colors
      set -g pane-border-style fg=colour240
      set -g pane-active-border-style fg=green

      # Message style (shown when you run commands)
      set -g message-style fg=white,bg=black,bold

      # ============================================================================
      # Tmux Plugin Manager (TPM)
      # ============================================================================
      
      # TPM allows you to install tmux plugins easily
      # Plugins extend tmux functionality without rebuilding your nix config
      
      # List of plugins to install
      # To install plugins: prefix + I (capital i)
      # To update plugins: prefix + U
      # To remove plugins: prefix + alt + u
      
      # Example plugins (uncomment to use):
      # set -g @plugin 'tmux-plugins/tmux-sensible'       # Basic tmux settings everyone can agree on
      # set -g @plugin 'tmux-plugins/tmux-resurrect'      # Save and restore tmux sessions
      # set -g @plugin 'tmux-plugins/tmux-continuum'      # Automatic session saving
      # set -g @plugin 'tmux-plugins/tmux-yank'           # Enhanced copying to system clipboard
      # set -g @plugin 'tmux-plugins/tmux-pain-control'   # Better pane control bindings
    '';

    # Plugins can also be managed declaratively via Nix (alternative to TPM)
    # This approach is more reproducible but requires rebuilding your config
    # Uncomment and add plugins here if you prefer nixpkgs plugin management:
    # plugins = with pkgs.tmuxPlugins; [
    #   sensible      # Basic tmux settings
    #   yank          # Copy to system clipboard
    #   resurrect     # Save and restore sessions
    # ];
  };
}
