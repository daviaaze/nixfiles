{ pkgs, config, ... }: {
  imports = [
    ./hardware.nix
    ./pipewire.nix
  ];

  services = {
    fwupd.enable = true;
    udisks2.enable = true;
    tailscale.enable = true;
    udev.extraRules = ''
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="2df0", ATTRS{idProduct}=="0003", TAG+="uaccess"
    '';
  };

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };

  programs.dconf.enable = true;

  users.users.daviaaze.extraGroups = [ "libvirtd" ];

  services.spice-vdagentd.enable = true;

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
      };
    };
    firewall = {
      enable = true;
      checkReversePath = "loose";
      trustedInterfaces = [ "br-824ccdbb8b3d" ];
    };
  };

  programs = {
    zsh.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira
  ];

  nixpkgs = {
    config.allowUnfree = true;
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
      vesktop
      usbutils
      exfat
      openssl
      virt-manager
      virt-viewer
      spice
      spice-gtk
      spice-protocol
      win-virtio
      win-spice
    ];
    pathsToLink = [ "/share/zsh" ];
    shells = [ pkgs.zsh ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  xdg.portal.wlr.enable = true;

  services.fprintd.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    # for packages that are pkgs.*
    gnome-tour
    gnome-connections
    # for packages that are pkgs.gnome.*
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-terminal
    gnome-console
  ]);

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "br";
    xkb.variant = "";
  };

  system.stateVersion = "23.11";
}
