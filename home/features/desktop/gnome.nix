{ pkgs, ... }: {
  home.packages = with pkgs; [
    qalculate-gtk
    libgnome-keyring
    gnome-control-center
    gensio
    adwaita-icon-theme
    gnomeExtensions.vitals
    gnomeExtensions.appindicator
    gnomeExtensions.wireless-hid
    gnomeExtensions.focused-window-d-bus
    gnomeExtensions.steal-my-focus-window
    gnomeExtensions.gsconnect
    gnomeExtensions.caffeine
    (pkgs.callPackage ../../../packages/pano.nix { })
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
    "org/gnome/desktop/wm/keybindings" = {
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
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
      command = "ghostty";
      name = "open-terminal";
    };
  };
}
