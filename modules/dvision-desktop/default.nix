{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./pipewire.nix
    # ./hyprland.nix
  ];

  networking.hostName = "dvision-desktop";
  networking.networkmanager.enable = true;

  security = {
    polkit.enable = true;
    pam.services.gtklock = { };
  };

  services = {
    fwupd.enable = true;
    blueman.enable = true;
  };

  virtualisation.docker.enable = true;

  programs = {
    zsh.enable = true;
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira
  ];

  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
    };
  };

nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      LIBVA_DRIVER_NAME="nvidia";
      XDG_SESSION_TYPE="wayland";
      GBM_BACKEND="nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME="nvidia";
      WLR_NO_HARDWARE_CURSORS="1";
      XDG_CURRENT_DESKTOP = "hyprland";
    };
    systemPackages = with pkgs; [
      direnv
      git
      glib
      qt6.qtwayland
      libva
    ];
    pathsToLink = [ "/share/zsh" ];
    shells = [ pkgs.zsh ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  xdg.portal.wlr.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "br";
    xkbVariant = "";
  };

  system.stateVersion = "22.11"; 
}