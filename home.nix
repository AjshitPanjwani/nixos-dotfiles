{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
    create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    configs = {
        nvim = "nvim";
        alacritty = "alacritty";
        mpv = "mpv";
    };
in

{
  home.username = "alien";
  home.homeDirectory = "/home/alien";
  programs.git.enable = true;
  home.stateVersion = "26.05";

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
      nixos-clean = "sudo nix-env --profile /nix/var/nix/profiles/system --delete-generations old; sudo nix-collect-garbage -d; sudo nix-store --optimise";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos-btw";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
        source = create_symlink "${dotfiles}/${subpath}";
        recursive = true;
    }) configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc 
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

}
