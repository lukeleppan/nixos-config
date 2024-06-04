{ config, ... }:
{
  imports = [
    ./general
    ./home-manager.nix
    ./nixvim.nix
  ];
}
