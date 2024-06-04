{ lib, ... }: {
  imports = [ ];

  hardware = {
    asahi = {
      peripheralFirmwareDirectory = ../../firmware;
      withRust = true;
      useExperimentalGPUDriver = true;
      experimentalGPUInstallMode = "replace";
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = lib.mkForce false;
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
