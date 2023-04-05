  { inputs, pkgs, ... }: {

  imports = [
    # ./hyprland.nix
    # ./wofi.nix
    # ./waybar.nix
    # ./polkit-agent.nix
    ./kitty.nix
    # ./swaync.nix
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