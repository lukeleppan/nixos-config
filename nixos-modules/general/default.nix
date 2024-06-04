{ config, ... }: {
  imports = [
    ./hardware.nix
    ./networking.nix
    ./nix-settings.nix
    ./services.nix
    ./packages.nix
  ];
}
