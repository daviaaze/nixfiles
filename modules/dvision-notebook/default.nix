{ pkgs, ... }: {
  imports = [
    ./hardware.nix
    # ./pipewire.nix
  ];

  networking.hostName = "dvision-notebook";
  networking.networkmanager.enable = true;

  security = {
    polkit.enable = true;
    pam.services.gtklock = { };
  };

  services = {
    fwupd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  programs = {
    zsh.enable = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira
  ];

  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = pkgs: { };
  };

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  environment = {
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

  system.stateVersion = "23.11";
}
