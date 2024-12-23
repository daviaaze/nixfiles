{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
  ];

  sops.secrets.cloudflared_token = {
    owner = "cloudflared";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dvision-homelab";

  modules = {
    pelican-wings.enable = true;
    cloudflared.enable = true;
    nginx = {
      enable = true;
      panel = {
        enable = true;
        enableSSL = false;
      };
    };
  };

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    cloudflared = {
      enable = true;
      tunnels = {
        "bb9d5525-147a-4b39-9352-d994f473a638" = {
          credentialsFile = config.sops.secrets.cloudflared_token.path;
          default = "http_status:404";
          ingress = {
            "*.daviaaze.com" = {
              service = "http://localhost:80";
            };
          };
        };
      };
    };
  };
  virtualisation = {
    docker = {
      enable = true;
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
    nerd-fonts.fira-code
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowBroken = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      firmware-updater
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
  networking.networkmanager.enable = true;
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "br";
    xkb.variant = "";
  };

  system.stateVersion = "23.11";
}
