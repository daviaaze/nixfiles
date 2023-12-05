{ inputs, pkgs, ... }: {

  imports = [
    ./kitty.nix
    ./zsh.nix
    ./neovim.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "22.11";
    packages = with pkgs; [
      spotify
      slack
      webcord
      vscode
      nil
      nixpkgs-fmt
      firefox
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
