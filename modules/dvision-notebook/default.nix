{ pkgs, ... }: {
  imports = [
    ./hardware.nix
  ];

  services = {
    fwupd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
  };

  networking = {
    hostName = "dvision-notebook";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ "br-6a5cd8abb3e0" ];
    };
  };


    programs = {
      zsh.enable = true;
      steam = {
        enable = true;
        remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      };
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
        libva
        steam-run-native
        steam
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
      xkb.layout = "br";
      xkb.variant = "";
    };

    system.stateVersion = "23.11";
  }
