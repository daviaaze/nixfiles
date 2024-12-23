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
    beszel = {
      enable = true;
      port = 45876;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGd3pPaRpvSfZulrZ6Au7x4grtoRn8UeNN1IEHnE1y20";
      hub = {
        enable = true;
      };
    };
    nginx = {
      enable = true;
      domainName = "daviaaze.com";
      panel = {
        enable = true;
        enableSSL = false;
      };
      beszel = {
        enable = true;
      };
    };
  };

  services = {
    openssh.enable = true;
    fwupd.enable = true;
    cloudflared = {
      enable = true;
      tunnels = {
        "84d5de41-70ff-4701-ab67-2c36f8667801" = {
          credentialsFile = config.sops.secrets.cloudflared_token.path;
          warp-routing.enabled = true;
          ingress = {
            "node.daviaaze.com" = {
              service = "http://localhost:8443";
            };
            "*.daviaaze.com" = {
              service = "http://localhost:80";
            };
          };
          default = "http_status:404";
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

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  system.stateVersion = "23.11";
}
