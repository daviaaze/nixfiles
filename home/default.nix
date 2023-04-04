  { inputs, pkgs, ... }: {

  imports = [
    ./hyprland.nix
    ./wofi.nix
    ./waybar.nix
    ./polkit-agent.nix
    ./kitty.nix
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
      qalculate-gtk
      gsettings-desktop-schemas
      libnotify
      pavucontrol
    ];
  };
  
  programs = {
    home-manager.enable = true;
  };
}