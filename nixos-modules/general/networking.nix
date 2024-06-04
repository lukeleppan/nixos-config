{ config, ... }: {
  imports = [ ];

  networking = {
    hostName = "lukenix"; # Define hostname.
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    # wireless = {
    # enable = true;
    # iwd = {
    #   enable = true;
    #   settings.General.EnableNetworkConfiguration = true;
    # };
    # };
  };

}
