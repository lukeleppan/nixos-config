{ config, ... }: {
  imports = [ ];

  services = {
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    fwupd.enable = true;

    upower.enable = true;

    xserver = {
      enable = true;
      xkb.variant = "mac";
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
    libinput = {
      enable = true;
      touchpad = {
        tapping = true;
        middleEmulation = true;
        naturalScrolling = false;
      };
    };
    desktopManager = { plasma6.enable = false; };
  };
}
