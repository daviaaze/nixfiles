{ pkgs, ... }: {
  home.packages = with pkgs; [
    qalculate-gtk
    gnome.adwaita-icon-theme
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.pano
    gnomeExtensions.vitals
    gnomeExtensions.forge
    gnomeExtensions.wireless-hid
    gnomeExtensions.steal-my-focus-window
    smile
  ];
}
