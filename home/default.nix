{ pkgs, ... }: {

  imports = [
    ./kitty.nix
    ./zsh.nix
    ./neovim.nix
    ./services.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "22.11";
    packages = with pkgs; [
      spotify
      slack
      discord
      redisinsight
      vscode
      nil
      nixpkgs-fmt
      firefox
      insomnia
      tidal-hifi
      pavucontrol
      stremio
      python3
      gnome.adwaita-icon-theme
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.pano
      gnomeExtensions.vitals
      gnomeExtensions.forge
      qalculate-gtk
      github-desktop
      gh
      heroku
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
