{ pkgs, inputs, ... }: {
  imports = [
    ./hardware.nix
    ./lenovo.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs.inputs = inputs;
        users.daviaaze.imports = [
          ../../home
        ];
      };
    }
  ];

  networking.hostName = "dvision-thinkbook";

  services = {
    fwupd.enable = true;
    udisks2.enable = true;
    cpupower-gui.enable = true;
    pipewire.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
  };

  virtualisation = {
    docker = {
      enable = true;
    };
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
    noisetorch.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  environment = {
    sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 = (
      pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (
        with pkgs.gst_all_1;
        [
          gst-plugins-good
          gst-plugins-bad
          gst-plugins-ugly
          gst-libav
        ]
      )
    );
    systemPackages = with pkgs; [
      direnv
      git
      glib
      libva
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
      intelmetool # For Intel ME tools
      chipsec # For platform security assessment
      fwts # Firmware test suite
      bitwarden-desktop
      devbox
      mesa
      openh264
      ffmpeg
      gst_all_1.gst-plugins-base
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-libav
      gst_all_1.gst-vaapi
    ];
    pathsToLink = [ "/share/zsh" ];
    shells = [ pkgs.zsh ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  xdg.portal.wlr.enable = true;

  # Enable the GNOME Desktop Environment.
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
