{ lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      live_config_reload = true;

      env = { };

      window = {
        dimensions = {
          columns = 0;
          lines = 0;
        };
        position = "None";
        padding = {
          x = 0;
          y = 0;
        };
        dynamic_padding = true;
        decorations = "None";
        opacity = 0.9;
        blur = true;
        startup_mode = "Maximized";
        title = "Alacritty";
        dynamic_title = true;
        class.general = "Alacritty";
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = 14;
        normal = { family = "JetBrainsMono Nerd Font"; };
        bold = { family = "JetBrainsMono Nerd Font"; };
        italic = { family = "JetBrainsMono Nerd Font"; };
        bold_italic = { family = "JetBrainsMono Nerd Font"; };
      };

      selection.save_to_clipboard = true;

      cursor.style = {
        shape = "Block";
        blinking = "On";
      };

      terminal.osc52 = "CopyPaste";

      mouse.hide_when_typing = false;

      # hints.enabled = [{
      #   command = "xdg-open";
      #   hyperlinks = true;
      #   post_processing = true;
      #   mouse.enabled = true;
      #   binding = {
      #     key = "U";
      #     mods = "Control|Shift";
      #   };
      #   regex = ''
      #     (ipfs:|ipns:|magnet:|mailto:|gemini://|gopher://|https://|http://|news:|file:|git://|ssh:|ftp://)[^\u0000-\u001F\u007F-\u009F<>\"\\s{-}\\^⟨⟩`]+'';
      # }];

      # Catppuccin Colors
      colors.primary = {
        background = lib.mkForce "#1E1E2E";
        foreground = lib.mkForce "#CDD6F4";
        dim_foreground = lib.mkForce "#CDD6F4";
        bright_foreground = lib.mkForce "#CDD6F4";
      };

      colors.cursor = {
        text = lib.mkForce "#1E1E2E";
        cursor = lib.mkForce "#F5E0DC";
      };

      colors.vi_mode_cursor = {
        text = lib.mkForce "#1E1E2E";
        cursor = lib.mkForce "#B4BEFE";
      };

      colors.search.matches = {
        foreground = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#A6ADC8";
      };

      colors.search.focused_match = {
        foreground = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#A6E3A1";
      };

      colors.footer_bar = {
        foreground = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#A6ADC8";
      };

      colors.hints.start = {
        foreground = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#F9E2AF";
      };

      colors.hints.end = {
        foreground = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#A6ADC8";
      };

      colors.selection = {
        text = lib.mkForce "#1E1E2E";
        background = lib.mkForce "#F5E0DC";
      };

      colors.normal = {
        black = lib.mkForce "#45475A";
        red = lib.mkForce "#F38BA8";
        green = lib.mkForce "#A6E3A1";
        yellow = lib.mkForce "#F9E2AF";
        blue = lib.mkForce "#89B4FA";
        magenta = lib.mkForce "#F5C2E7";
        cyan = lib.mkForce "#94E2D5";
        white = lib.mkForce "#BAC2DE";
      };

      colors.bright = {
        black = lib.mkForce "#585B70";
        red = lib.mkForce "#F38BA8";
        green = lib.mkForce "#A6E3A1";
        yellow = lib.mkForce "#F9E2AF";
        blue = lib.mkForce "#89B4FA";
        magenta = lib.mkForce "#F5C2E7";
        cyan = lib.mkForce "#94E2D5";
        white = lib.mkForce "#A6ADC8";
      };

      colors.dim = {
        black = lib.mkForce "#45475A";
        red = lib.mkForce "#F38BA8";
        green = lib.mkForce "#A6E3A1";
        yellow = lib.mkForce "#F9E2AF";
        blue = lib.mkForce "#89B4FA";
        magenta = lib.mkForce "#F5C2E7";
        cyan = lib.mkForce "#94E2D5";
        white = lib.mkForce "#BAC2DE";
      };

      colors.indexed_colors = [
        {
          index = 16;
          color = "#FAB387";
        }
        {

          index = 17;
          color = "#F5E0DC";
        }
      ];
    };
  };
}
