{ pkgs, ... }:
let
  changeWallpaperScript = pkgs.pkgs.writeShellScriptBin "changeWallpaper" ''
    #!/bin/bash

    # Directory containing your wallpapers
    WALLPAPER_DIR="$HOME/wallpapers"

    # Get a list of all image files in the wallpaper directory
    WALLPAPERS=$(ls $WALLPAPER_DIR)

    # Number of wallpapers
    NUM_WALLPAPERS=$(echo "$WALLPAPERS" | wc -l)

    # Current wallpaper index
    CURRENT_WALLPAPER=0

    # Convert WALLPAPERS to an array
    WALLPAPERS_ARRAY=($WALLPAPERS)

    # Loop to change wallpaper every 30 seconds
    while true; do
      CURRENT_WALLPAPER_FILE="$WALLPAPER_DIR/${
        "\${WALLPAPERS_ARRAY[$CURRENT_WALLPAPER]}"
      }"
      
      # Check if the wallpaper file exists
      if [ ! -f "$CURRENT_WALLPAPER_FILE" ]; then
        echo "Wallpaper file does not exist: $CURRENT_WALLPAPER_FILE"
        exit 1
      fi
      
      echo "Setting wallpaper to: $CURRENT_WALLPAPER_FILE"
      swww img "$CURRENT_WALLPAPER_FILE" --transition-type center
      
      CURRENT_WALLPAPER=$(( (CURRENT_WALLPAPER + 1) % NUM_WALLPAPERS ))
      sleep 600
    done
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$menu" = "rofi -show drun";

      monitor = "eDp-1, preferred, auto, 2";

      "exec-once" = [
        "waybar &"
        "swww-daemon --format xrgb"
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "hypridle &"
        "pypr &"
        "${changeWallpaperScript}/bin/changeWallpaper &"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;

        border_size = 2;

        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";

        # Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false;

        # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false;

        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 0.9;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";

        # https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
          enabled = true;
          size = 6;
          passes = 2;

          ignore_opacity = true;
          new_optimizations = true;
          special = true;

          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true; # You probably want this
      };

      master = { new_is_master = true; };

      misc = {
        force_default_wallpaper = -1;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        #vrr = 0
        enable_swallow = true;
        no_direct_scanout = true; # for fullscreen games
        focus_on_activate = false;
        #disable_autoreload = true
      };

      input = {
        kb_layout = "us";
        #kb_variant =
        #kb_model =
        #kb_options =
        #kb_rules =

        follow_mouse = 1;

        sensitivity = -0.1; # -1.0 - 1.0, 0 means no modification.

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          middle_button_emulation = true;
          drag_lock = false;
        };
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 3;
        workspace_swipe_distance = 400;
        workspace_swipe_invert = true;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = true;
        workspace_swipe_forever = true;
      };

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      workspace = [
        "1, monitor:eDP-1, default:true"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
      ];

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod, Q, killactive"
        "$mod, M, exit"
        "$mod, E, exec, $fileManager"
        "$mod, V, togglefloating,"
        "$mod, Space, exec, $menu"
        "$mod, P, pseudo" # dwindle
        "$mod, J, togglesplit" # dwindle

        # Move focus with mainMod + arrow keys
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-9]
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"

        # Example special workspace (scratchpad)
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"

        # Scroll through existing workspaces with mainMod + scroll
        #"$mod, mouse_down, workspace, e+1"
        #"$mod, mouse_up, workspace, e-1"
      ];
    };
  };
}
