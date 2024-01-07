{ pkgs, ... }: {

  imports = [
    ./zsh.nix
    ./services.nix
    ./neovim.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "22.11";
    packages = with pkgs; [
      spotify
      slack
      discord
      vscode
      nil
      nixpkgs-fmt
      firefox
      tidal-hifi
      github-desktop
      stremio
      python3
      gnome.adwaita-icon-theme
      gnomeExtensions.bluetooth-quick-connect
      gnomeExtensions.pano
      gnomeExtensions.vitals
      gnomeExtensions.forge
      gnomeExtensions.wireless-hid
      gnomeExtensions.steal-my-focus-window
      qalculate-gtk
      jetbrains.datagrip
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
