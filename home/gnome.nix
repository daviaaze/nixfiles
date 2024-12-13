{ pkgs, ... }: {
  home.packages = with pkgs; [
    qalculate-gtk
    libgnome-keyring
    gnome-control-center
    gensio
    pkgs.adwaita-icon-theme
    gnomeExtensions.bluetooth-quick-connect
    gnomeExtensions.vitals
    gnomeExtensions.appindicator
    gnomeExtensions.wireless-hid
    gnomeExtensions.focused-window-d-bus
    gnomeExtensions.steal-my-focus-window
    gnomeExtensions.gsconnect
    (callPackage ../packages/pano.nix {})
    smile
    pwvucontrol
  ];

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-weekday = true;
      clock-show-seconds = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
    };
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Primary><Alt>t";
      command = "kitty";
      name = "open-terminal";
    };
  };
}
