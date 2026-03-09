{ config, pkgs, ... }:

{
  # Alacritty is a fast, GPU-accelerated terminal emulator written in Rust
  # It's simple, modern, and highly performant
  programs.alacritty = {
    # Enable alacritty installation and configuration via Home Manager
    enable = true;

    # Settings is where all the alacritty configuration goes
    settings = {
      # Window configuration - controls the terminal window appearance
      window = {
        # Window dimensions in characters (columns x rows)
        dimensions = {
          columns = 120;  # Width of the terminal window
          lines = 30;     # Height of the terminal window
        };

        # Padding (in pixels) around the terminal content
        padding = {
          x = 10;  # Horizontal padding (left/right)
          y = 10;  # Vertical padding (top/bottom)
        };

        # Window opacity from 0.0 (transparent) to 1.0 (opaque)
        # Can be useful for seeing things behind the terminal
        opacity = 1.0;

        # Enhance the window appearance with transparency and blur effects
        # Note: Only works on some desktop environments
        blur = 0;  # Set to a value > 0 to enable blur
      };

      # Font configuration - what text looks like
      font = {
        # Normal font settings
        normal = {
          # Family should be a monospace font available on your system
          # Common options: "Monospace", "Liberation Mono", "JetBrains Mono", "Fira Code"
          family = "Monospace";
          
          # Font style - usually "Regular"
          style = "Regular";
        };

        # Bold font variant
        bold = {
          family = "Monospace";
          style = "Bold";
        };

        # Italic font variant
        italic = {
          family = "Monospace";
          style = "Italic";
        };

        # Font size in points
        size = 12.0;

        # Letter spacing - space between characters
        # Positive values increase spacing, negative decrease it
        letter_spacing = 0.0;

        # Line spacing - vertical space between lines
        line_spacing = 0.0;
      };

      # Color scheme - the colors used in the terminal
      # This uses a simple Dracula-inspired color scheme
      colors = {
        # Primary colors - background and foreground
        primary = {
          background = "#282a36";  # Dark background
          foreground = "#f8f8f2";  # Light foreground (text)
        };

        # Cursor appearance
        cursor = {
          text   = "#282a36";  # Color of the text in the cursor
          cursor = "#f8f8f2";  # Color of the cursor itself
        };

        # ANSI colors for terminal output (0-7 are normal, 8-15 are bright)
        normal = [
          "#282a36"  # Black
          "#ff5555"  # Red
          "#50fa7b"  # Green
          "#f1fa8c"  # Yellow
          "#bd93f9"  # Blue
          "#ff79c6"  # Magenta
          "#8be9fd"  # Cyan
          "#bfbfbf"  # White
        ];

        # Bright ANSI colors
        bright = [
          "#4d4d4d"  # Bright Black
          "#ff6e6e"  # Bright Red
          "#69ff94"  # Bright Green
          "#ffffa5"  # Bright Yellow
          "#d6acff"  # Bright Blue
          "#ff92df"  # Bright Magenta
          "#a4ffff"  # Bright Cyan
          "#ffffff"  # Bright White
        ];
      };

      # Keyboard configuration
      keyboard = {
        # Bindings define custom key combinations and actions
        bindings = [
          # Create new terminal window with Alt+N
          { key = "N"; mods = "Alt"; action = "CreateNewWindow"; }
        ];
      };

      # Bell configuration - sound/visual alerts
      bell = {
        # Animation for visual bell (changes window appearance briefly)
        animation = "EaseOutExpo";
        # Duration of the bell animation in milliseconds
        duration = 0;
        # Visual bell color (flashes this color)
        color = "#ffffff";
      };

      # Scrollback - how much history to keep
      scrollback.lines = 10000;  # Number of lines to keep in history

      # Mouse configuration
      mouse = {
        # Hide the cursor when typing
        hide_when_typing = true;
      };

      # URL handling - what happens when you click URLs in the terminal
      # Note: This is a basic setup; you can configure specific URL patterns
      hints = {
        # Custom URL matcher - matches web URLs
        # You can add more patterns here for other URL types
        enabled = [
          {
            # Pattern to match URLs in terminal output
            regex = "(ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|nntp:|telnet:|wss://|ws://)[^\\u0000-\\u001F\\u007F-\\u009F<>\"\\s{-}\\\\^⟨⟩]+" ;
            # Command to open matched URLs
            command = "xdg-open";
            # Post-processing of the URL before opening
            post_processing = true;
            # Label shown when hovering over the URL
            label = "Open";
          }
        ];
      };
    };
  };
}
