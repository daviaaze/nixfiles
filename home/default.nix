{ pkgs, inputs, ... }: {
  imports = [
    ./zsh.nix
    ./services.nix
    ./neovim.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    packages = with pkgs; [
      spotify
      alacritty
      slack
      webcord
      nil
      nixpkgs-fmt
      firefox
      tidal-hifi
      vscode
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
      insomnia
      gimp
      inputs.luxuryescapes-cli.packages.${system}.default
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
