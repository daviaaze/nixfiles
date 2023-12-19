{ pkgs, ... }: {

  imports = [
    ./zsh.nix
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
      stremio
      python3
      gnome.adwaita-icon-theme
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.pano
      gnomeExtensions.vitals
      gnomeExtensions.forge
      qalculate-gtk
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
