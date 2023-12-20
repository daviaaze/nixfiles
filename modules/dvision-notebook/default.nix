{ pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "dvision-notebook";
  networking.networkmanager.enable = true;

  # security = {
  #   polkit.enable = true;
  #   acme.acceptTerms = true;
  #   acme.defaults.email = "daviaaze@gmail.com";
  #   pam.services.gtklock = { };
  # };

  services = {
    fwupd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  networking.firewall.enable = true;
  networking.firewall.trustedInterfaces = [ "br-87b655316a81" ];

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
      libva
      bluez-alsa
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
