{ ... }: {
  programs.zellij = {
    enable = false;
    enableFishIntegration = true;
    settings = {
      default_shell = "fish";
      pane_frames = false;
      theme = "catppuccin-mocha";
      default_layout = "compact";
      mouse_mode = true;

      keybinds = {
        "shared_except" = [
          {
            _args = [ "pane" "locked" ];
            unbind = "ctrl p";
            bind = {
              _args = [ "ctrl a" ];
              SwitchToMode = "Pane";
            };
          }
          {
            _args = [ "resize" "locked" ];
            unbind = "ctrl n";
            bind = {
              _args = [ "ctrl 1" ];
              SwitchToMode = "Resize";
            };
          }
        ];
      };
    };
  };
}
