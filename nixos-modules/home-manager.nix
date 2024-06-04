{ config, pkgs, ... }: {
  imports = [ <home-manager/nixos> <catppuccin/modules/nixos> ];

  home-manager.backupFileExtension = "backup";
  home-manager.users.lukeleppan = {
    imports = [
      <catppuccin/modules/home-manager>
      ./home-modules/alacritty.nix
      ./home-modules/eww.nix
      ./home-modules/hypridle.nix
      ./home-modules/hyprland.nix
      ./home-modules/hyprlock.nix
      ./home-modules/rofi.nix
      ./home-modules/swaync.nix
      ./home-modules/waybar.nix
    ];
    home.packages = with pkgs; [ waybar ];

    catppuccin.enable = true;

    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "mocha";
        accent = "pink";
        size = "standard";
        tweaks = [ "normal" ];
      };
    };

    programs = {

      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          eval (zellij setup --generate-auto-start fish | string collect)
        '';
        plugins = [ ];
        shellAliases = {
          v = "nvim";
          rebuild =
            "sudo nixos-rebuild switch -I nixos-config=/home/lukeleppan/nixos-config/configuration.nix";
        };
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      atuin = {
        enable = true;
        enableFishIntegration = true;
      };

      fzf = {
        enable = true;
        enableFishIntegration = true;
      };

      eza = {
        enable = true;
        enableFishIntegration = true;
      };

      git = {
        enable = true;
        userName = "Luke Leppan";
        userEmail = "lukelepp@gmail.com";
        delta.enable = true;
      };
    };

    home.stateVersion = "24.05";
  };
}
