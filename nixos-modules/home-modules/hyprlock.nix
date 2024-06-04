{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 1;

      };

      background = {
        path = "screenshot";

        blur_size = 6;
        blur_passes = 2;
        noise = 1.17e-2;
        contrast = 1.3;
        brightness = 0.8;
        vibrancy = 0.21;
        vibrancy_darkness = 0.0;
      };

      input-field = {
        size = "250, 50";
        outline_thickness = 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        #outer_color = $color5;
        #inner_color = $color0;
        #font_color = $color12;
        fade_on_empty = true;
        placeholder_text =
          "<i>Password...</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;

        position = "0, 200";
        halign = "center";
        valign = "bottom";
      };

      label = [
        # Date
        {
          text =
            ''cmd[update:18000000] echo "<b> "$(date +'%A, %-d %B %Y')" </b>"'';
          #color = $color12
          font_size = 34;
          font_family = "JetBrains Mono Nerd Font 10";

          position = "0, -150";
          halign = "center";
          valign = "top";
        }

        # Week
        {
          text = ''cmd[update:18000000] echo "<b> "$(date +'Week %U')" </b>"'';
          #color = $color5
          font_size = 24;
          font_family = "JetBrains Mono Nerd Font 10";
          position = "0, -250";
          halign = "center";
          valign = "top";
        }

        # Time
        {
          text = ''
            cmd[update:1000] echo "<b><big> $(date +"%H:%M:%S") </big></b>"
          ''; # 24H

          #color = $color15
          font_size = 94;
          font_family = "JetBrains Mono Nerd Font 10";

          position = "0, 0";
          halign = "center";
          valign = "center";
        }

        # User
        {
          text = "   $USER";
          #color = $color12
          font_size = 18;
          font_family = "JetBrains Mono Nerd Font 10";

          position = "0, 100";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
