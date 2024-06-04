{ pkgs, ... }:
let
  volumeScript = pkgs.pkgs.writeShellScriptBin "volume" ''
    inc_volume() {
        if [ "$(pamixer --get-mute)" == "true" ]; then
            toggle_mute
        else
            pamixer -i 5 --allow-boost --set-limit 150
        fi
    }
    dec_volume() {
        if [ "$(pamixer --get-mute)" == "true" ]; then
            toggle_mute
        else
            pamixer -d 5
        fi
    }
    toggle_mute() {
    	if [ "$(pamixer --get-mute)" == "false" ]; then
    		pamixer -m && notify-send -e -u low -i "$iDIR/volume-mute.png" "Volume Switched OFF"
    	elif [ "$(pamixer --get-mute)" == "true" ]; then
    		pamixer -u && notify-send -e -u low -i "$(get_icon)" "Volume Switched ON"
    	fi
    }
    toggle_mic() {
    	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
    		pamixer --default-source -m && notify-send -e -u low -i "$iDIR/microphone-mute.png" "Microphone Switched OFF"
    	elif [ "$(pamixer --default-source --get-mute)" == "true" ]; then
    		pamixer -u --default-source u && notify-send -e -u low -i "$iDIR/microphone.png" "Microphone Switched ON"
    	fi
    }
    inc_mic_volume() {
        if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
            toggle_mic
        else
            pamixer --default-source -i 5
        fi
    }
    dec_mic_volume() {
        if [ "$(pamixer --default-source --get-mute)" == "true" ]; then
            toggle-mic
        else
            pamixer --default-source -d 5
        fi
    }

    if [[ "$1" == "--inc" ]]; then
    	inc_volume
    elif [[ "$1" == "--dec" ]]; then
    	dec_volume
    elif [[ "$1" == "--toggle" ]]; then
    	toggle_mute
    elif [[ "$1" == "--toggle-mic" ]]; then
    	toggle_mic
    elif [[ "$1" == "--mic-inc" ]]; then
    	inc_mic_volume
    elif [[ "$1" == "--mic-dec" ]]; then
    	dec_mic_volume
    fi
  '';

  brightnessScript = pkgs.pkgs.writeShellScriptBin "brightness" ''
    get_backlight() {
    	echo $(brightnessctl -m | cut -d, -f4)
    }

    # Change brightness
    change_backlight() {
    	brightnessctl set "$1"
    }

    # Execute accordingly
    case "$1" in
    	"--inc")
    		change_backlight "+10%"
    		;;
    	"--dec")
    		change_backlight "10%-"
    		;;
    esac  
  '';
  wlogoutScript = pkgs.pkgs.writeShellScriptBin "Wlogout" ''
    if pgrep -x "wlogout" > /dev/null; then
        pkill -x "wlogout"
        exit 0
    fi
    wlogout &
  '';
in {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        "layer" = "top";
        # "exclusive" = "true";
        "passthrough" = "false";
        "position" = "top";
        "spacing" = 3;
        # "fixed-center" = "true";
        "ipc" = "true";
        "margin-top" = 3;
        "margin-left" = 8;
        "margin-right" = 8;

        "modules-left" = [
          "custom/menu"
          "custom/separator#line"
          "clock"
          "group/mobo_drawer"
          "custom/separator#line"
          "hyprland/workspaces"
        ];

        "modules-right" = [
          "tray"
          "custom/separator#line"
          "network"
          "bluetooth"
          "group/audio"
          "group/laptop"
          "custom/separator#line"
          "custom/swaync"
          "custom/lock"
          "custom/power"
        ];

        "custom/menu" = {
          "format" = "{}";
          "exec" = "echo ; echo 󱓟 app launcher";
          "interval" = 86400;
          "tooltip" = true;
          "on-click" =
            "pkill rofi || rofi -show drun -modi run,drun,filebrowser,window";
          "on-click-middle" = "~/.config/hypr/UserScripts/WallpaperSelect.sh";
          "on-click-right" = "~/.config/hypr/scripts/WaybarLayout.sh";
        };

        "custom/separator#line" = {
          "format" = "|";
          "interval" = "once";
          "tooltip" = false;
        };

        "group/mobo_drawer" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "cpu";
            "transition-left-to-right" = true;
          };
          "modules" = [ "temperature" "cpu" "memory" "disk" ];
        };

        "temperature" = {
          "interval" = 10;
          "tooltip" = true;
          "hwmon-path" = [
            "/sys/class/hwmon/hwmon1/temp1_input"
            "/sys/class/thermal/thermal_zone0/temp"
          ];
          "critical-threshold" = 82;
          "format-critical" = "{temperatureC}°C {icon}";
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [ "󰈸" ];
          "on-click-right" = "kitty --title nvtop sh -c 'nvtop'";
        };

        "cpu" = {
          "format" = "{usage}% 󰍛";
          "interval" = 1;
          "format-alt-click" = "click";
          "format-alt" = "{icon0}{icon1}{icon2}{icon3} {usage:>2}% 󰍛";
          "format-icons" = [ "▁" "▂" "▃" "▄" "▅" "▆" "▇" "█" ];
          "on-click-right" = "gnome-system-monitor";
        };

        "memory" = {
          "interval" = 10;
          "format" = "{used:0.1f}G 󰾆";
          "format-alt" = "{percentage}% 󰾆";
          "format-alt-click" = "click";
          "tooltip" = true;
          "tooltip-format" = "{used:0.1f}GB/{total:0.1f}G";
          "on-click-right" = "alacritty -e sh -c 'btop'";
        };

        "disk" = {
          "interval" = 30;
          "path" = "/";
          "format" = "{percentage_used}% 󰋊";
          "tooltip-format" =
            "{used} used out of {total} on {path} ({percentage_used}%)";
        };

        "group/laptop" = {
          "orientation" = "inherit";
          "modules" = [ "backlight" "battery" ];
        };

        "backlight" = {
          "interval" = 2;
          "align" = 0;
          "rotate" = 0;
          "format" = "{icon} {percent}%";
          "format-icons" =
            [ "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ];
          "tooltip-format" = "backlight {percent}%";
          "icon-size" = 12;
          "on-click" = "";
          "on-click-middle" = "";
          "on-click-right" = "";
          "on-update" = "";
          "on-scroll-up" = "${brightnessScript}/bin/brightness --inc";
          "on-scroll-down" = "${brightnessScript}/bin/brightness --dec";
          "smooth-scrolling-threshold" = 1;
        };

        "battery" = {
          "align" = 0;
          "rotate" = 0;
          "full-at" = 100;
          "design-capacity" = false;
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = "󱘖 {capacity}%";
          "format-alt-click" = "click";
          "format-full" = "{icon} Full";
          "format-alt" = "{icon} {time}";
          "format-icons" = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          "format-time" = "{H}h {M}min";
          "tooltip" = true;
          "tooltip-format" = "{timeTo} {power}w";
          "on-click-middle" = "~/.config/hypr/scripts/ChangeBlur.sh";
          "on-click-right" = "${wlogoutScript}/bin/Wlogout";
        };

        "custom/swaync" = {
          "tooltip" = true;
          "format" = "{icon} {}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" =
              "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" =
              "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "sleep 0.1 && swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };

        "clock" = {
          "interval" = 1;
          "format" = " {:%H:%M:%S}";
          "format-alt" = " {:%H:%M   %Y, %d %B, %A}";
          "tooltip-format" = "<tt><small>{calendar}</small></tt>";
          "calendar" = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='#ffead3'><b>{}</b></span>";
              "days" = "<span color='#ecc6d9'><b>{}</b></span>";
              "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
              "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
              "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
        };

        "hyprland/workspaces" = {
          "active-only" = false;
          "all-outputs" = true;
          "format" = "{icon}";
          "show-special" = false;
          "on-click" = "activate";
          "on-scroll-up" = "hyprctl dispatch workspace e+1";
          "on-scroll-down" = "hyprctl dispatch workspace e-1";
          "persistent-workspaces" = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
          };
          "format-icons" = {
            "active" = "";
            "default" = "";
          };
        };

        "tray" = {
          "icon-size" = 14;
          "spacing" = 4;
        };

        "network" = {
          "format" = "{ifname}";
          "format-wifi" = "{icon}";
          "format-ethernet" = "󰌘";
          "format-disconnected" = "󰌙";
          "tooltip-format" =
            "{ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
          "format-linked" = "󰈁 {ifname} (No IP)";
          "tooltip-format-wifi" = "{essid} {icon} {signalStrength}%";
          "tooltip-format-ethernet" = "{ifname} 󰌘";
          "tooltip-format-disconnected" = "󰌙 Disconnected";
          "max-length" = 50;
          "format-icons" = [ "󰤯" "󰤟" "󰤢" "󰤥" "󰤨" ];
          "on-click-right" = "alacritty -e nmtui";
        };

        "bluetooth" = {
          "format" = "";
          "format-disabled" = "󰂳";
          "format-connected" = "󰂱 {num_connections}";
          "tooltip-format" = " {device_alias}";
          "tooltip-format-connected" = "{device_enumerate}";
          "tooltip-format-enumerate-connected" =
            " {device_alias} 󰂄{device_battery_percentage}%";
          "tooltip" = true;
          "on-click" = "blueman-manager";
        };

        "group/audio" = {
          "orientation" = "inherit";
          "drawer" = {
            "transition-duration" = 500;
            "children-class" = "pulseaudio";
            "transition-left-to-right" = true;
          };
          "modules" = [ "pulseaudio" "pulseaudio#microphone" ];
        };

        "pulseaudio" = {
          "format" = "{icon} {volume}%";
          "format-bluetooth" = "{icon} 󰂰 {volume}%";
          "format-muted" = "󰖁";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "󰕾" "" ];
            "ignored-sinks" = [ "Easy Effects Sink" ];
          };
          "scroll-step" = 5.0;
          "on-click" = "${volumeScript}/bin/volume --toggle";
          "on-click-right" = "pavucontrol -t 3";
          "on-scroll-up" = "${volumeScript}/bin/volume --inc";
          "on-scroll-down" = "${volumeScript}/bin/volume --dec";
          "tooltip-format" = "{icon} {desc} | {volume}%";
          "smooth-scrolling-threshold" = 1;
        };

        "pulseaudio#microphone" = {
          "format" = "{format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = "";
          "on-click" = "${volumeScript}/bin/volume --toggle-mic";
          "on-click-right" = "pavucontrol -t 4";
          "on-scroll-up" = "${volumeScript}/bin/volume --mic-inc";
          "on-scroll-down" = "${volumeScript}/bin/volume --mic-dec";
          "tooltip-format" = "{source_desc} | {source_volume}%";
          "scroll-step" = 5;
        };

        "custom/lock" = {
          "format" = "󰌾{}";
          "exec" = "echo ; echo 󰷛  screen lock";
          "interval" = 86400;
          "tooltip" = true;
          "on-click" = "~/.config/hypr/scripts/LockScreen.sh";
        };

        "custom/power" = {
          "format" = "⏻ ";
          "exec" = "echo ; echo 󰟡 power // blur";
          "on-click" = "${wlogoutScript}/bin/Wlogout";
          "on-click-right" = "~/.config/hypr/scripts/ChangeBlur.sh";
          "interval" = 86400;
          "tooltip" = true;
        };
      };
    };
    style = ''
      @define-color rosewater #f5e0dc;
      @define-color flamingo #f2cdcd;
      @define-color pink #f5c2e7;
      @define-color mauve #cba6f7;
      @define-color red #f38ba8;
      @define-color maroon #eba0ac;
      @define-color peach #fab387;
      @define-color yellow #f9e2af;
      @define-color green #a6e3a1;
      @define-color teal #94e2d5;
      @define-color sky #89dceb;
      @define-color sapphire #74c7ec;
      @define-color blue #89b4fa;
      @define-color lavender #b4befe;
      @define-color text #cdd6f4;
      @define-color subtext1 #bac2de;
      @define-color subtext0 #a6adc8;
      @define-color overlay2 #9399b2;
      @define-color overlay1 #7f849c;
      @define-color overlay0 #6c7086;
      @define-color surface2 #585b70;
      @define-color surface1 #45475a;
      @define-color surface0 #313244;
      @define-color base #1e1e2e;
      @define-color mantle #181825;
      @define-color crust #11111b;

      * {
      	font-family: "JetBrainsMono Nerd Font";
      	font-weight: bold;
      	min-height: 0;
      	/* set font-size to 100% if font scaling is set to 1.00 using nwg-look */
      	font-size: 97%;
      	font-feature-settings: '"zero", "ss01", "ss02", "ss03", "ss04", "ss05", "cv31"';
      	padding: 1px;
      }

      window#waybar {
      	transition-property: background-color;
      	transition-duration: 0.5s;
      	background: transparent;
      	/*border: 2px solid @overlay0;*/
      	/*background: @theme_base_color;*/
      	border-radius: 10px;
      }

      window#waybar.hidden {
      	opacity: 0.2;
      }

      #waybar.empty #window {
      	background: none;
      }

      /* This section can be use if you want to separate waybar modules */
      .modules-left,
      .modules-center,
      .modules-right {
      	background: @theme_base_color;
      	border: 0.5px solid @overlay0;
      	padding-top: 2px;
      	padding-bottom: 2px;
      	padding-right: 4px;
      	padding-left: 4px;
      	border-radius: 10px;
      }

      .modules-center {
        background: none;
        border: none;
      }

      .modules-left,
      .modules-right {
      	border: 1px solid @blue;
      	padding-top: 2px;
      	padding-bottom: 2px;
      	padding-right: 4px;
      	padding-left: 4px;
      }

      #backlight,
      #backlight-slider,
      #battery,
      #bluetooth,
      #clock,
      #cpu,
      #disk,
      #idle_inhibitor,
      #keyboard-state,
      #memory,
      #mode,
      #mpris,
      #network,
      #power-profiles-daemon,
      #pulseaudio,
      #pulseaudio-slider,
      #taskbar button,
      #taskbar,
      #temperature,
      #tray,
      #window,
      #wireplumber,
      #workspaces,
      #custom-backlight,
      #custom-cycle_wall,
      #custom-hint,
      #custom-keyboard,
      #custom-light_dark,
      #custom-lock,
      #custom-menu,
      #custom-power_vertical,
      #custom-power,
      #custom-swaync,
      #custom-updater,
      #custom-weather,
      #custom-weather.clearNight,
      #custom-weather.cloudyFoggyDay,
      #custom-weather.cloudyFoggyNight,
      #custom-weather.default,
      #custom-weather.rainyDay,
      #custom-weather.rainyNight,
      #custom-weather.severe,
      #custom-weather.showyIcyDay,
      #custom-weather.snowyIcyNight,
      #custom-weather.sunnyDay {
      	padding-top: 3px;
      	padding-bottom: 3px;
      	padding-right: 6px;
      	padding-left: 6px;
      }

      #idle_inhibitor {
      	color: @blue;
      }

      #bluetooth,
      #backlight {
      	color: @blue;
      }

      #battery {
      	color: @green;
      }

      @keyframes blink {
      	to {
      		color: @surface0;
      	}
      }

      #battery.critical:not(.charging) {
      	background-color: @red;
      	color: @theme_text_color;
      	animation-name: blink;
      	animation-duration: 0.5s;
      	animation-timing-function: linear;
      	animation-iteration-count: infinite;
      	animation-direction: alternate;
      	box-shadow: inset 0 -3px transparent;
      }

      #clock {
      	color: @yellow;
      }

      #cpu {
      	color: @green;
      }

      #custom-keyboard,
      #memory {
      	color: @sky;
      }

      #disk {
      	color: @sapphire;
      }

      #temperature {
      	color: @teal;
      }

      #temperature.critical {
      	background-color: @red;
      }

      #tray>.passive {
      	-gtk-icon-effect: dim;
      }

      #tray>.needs-attention {
      	-gtk-icon-effect: highlight;
      }

      #keyboard-state {
      	color: @flamingo;
      }

      #workspaces button {
      	box-shadow: none;
      	text-shadow: none;
      	padding: 0px;
      	border-radius: 9px;
      	padding-left: 4px;
      	padding-right: 4px;
      	animation: gradient_f 20s ease-in infinite;
      	transition: all 0.5s cubic-bezier(.55, -0.68, .48, 1.682);
      }

      #workspaces button:hover {
      	border-radius: 10px;
      	color: @overlay0;
      	background-color: @surface0;
      	padding-left: 2px;
      	padding-right: 2px;
      	animation: gradient_f 20s ease-in infinite;
      	transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
      }

      #workspaces button.persistent {
      	color: @surface1;
      	border-radius: 10px;
      }

      #workspaces button.active {
      	color: @peach;
      	border-radius: 10px;
      	padding-left: 8px;
      	padding-right: 8px;
      	animation: gradient_f 20s ease-in infinite;
      	transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
      }

      #workspaces button.urgent {
      	color: @red;
      	border-radius: 0px;
      }

      #taskbar button.active {
      	padding-left: 8px;
      	padding-right: 8px;
      	animation: gradient_f 20s ease-in infinite;
      	transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
      }

      #taskbar button:hover {
      	padding-left: 2px;
      	padding-right: 2px;
      	animation: gradient_f 20s ease-in infinite;
      	transition: all 0.3s cubic-bezier(.55, -0.68, .48, 1.682);
      }

      #custom-cava_mviz {
      	color: @pink;
      }

      #custom-menu {
      	color: @rosewater;
      }

      #custom-power {
      	color: @red;
      }

      #custom-updater {
      	color: @red;
      }

      #custom-light_dark {
      	color: @blue;
      }

      #custom-weather {
      	color: @lavender;
      }

      #custom-lock {
      	color: @maroon;
      }

      #pulseaudio {
      	color: @sapphire;
      }

      #pulseaudio.bluetooth {
      	color: @pink;
      }

      #pulseaudio.muted {
      	color: @red;
      }

      #window {
      	color: @mauve;
      }

      #custom-waybar-mpris {
      	color: @lavender;
      }

      #network {
      	color: @teal;
      }

      #network.disconnected,
      #network.disabled {
      	background-color: @surface0;
      	color: @text;
      }

      #pulseaudio-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #pulseaudio-slider trough {
      	min-width: 80px;
      	min-height: 5px;
      	border-radius: 5px;
      }

      #pulseaudio-slider highlight {
      	min-height: 10px;
      	border-radius: 5px;
      }

      #backlight-slider slider {
      	min-width: 0px;
      	min-height: 0px;
      	opacity: 0;
      	background-image: none;
      	border: none;
      	box-shadow: none;
      }

      #backlight-slider trough {
      	min-width: 80px;
      	min-height: 10px;
      	border-radius: 5px;
      }

      #backlight-slider highlight {
      	min-width: 10px;
      	border-radius: 5px;
      }
    '';
  };
}
