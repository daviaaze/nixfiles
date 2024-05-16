{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./services.nix
    ./neovim.nix
    ./gnome.nix
    ./work.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    packages = with pkgs; [
      spotify
      firefox
      stremio
      starsector
      git-lfs
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
