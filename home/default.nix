  { inputs, pkgs, ... }: {

  imports = [
    ./hyprland.nix
    ./wofi.nix
    ./waybar.nix
    ./polkit-agent.nix
    ./kitty.nix
    ./swaync.nix
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
      gcr
      gsettings-desktop-schemas
      swaybg
      wlsunset
      brightnessctl
      wl-clipboard
      darkman
      mpv
      imv
      shotman
      playerctl
    ];
  };
  
  programs = {
    home-manager.enable = true;
  };
}