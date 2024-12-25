{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
  ];

  sops.secrets.cloudflared_token = {
    owner = "cloudflared";
  };

  sops.secrets.cloudflare_api_token = { };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "dvision-homelab";

  networking.firewall.enable = true;

  users.groups.pelican = {
    gid = 657;
  };

  users.users.pelican = {
    isSystemUser = true;
    uid = 657;
    group = "pelican";
    extraGroups = [ "docker" ];
  };

  modules = {
    pelican-wings = {
      enable = true;
      debug = true;
      uuid = "1d8613be-bb19-4b91-8d99-6e49c447e48a";
      tokenId = "8Q0mz63fiTZKjLW3";
      token = "dlVjopbgFqRWt3kfFa9nJnhilsmwT9JxANFSBnO5FJX1Nalu0uGhY6ZBWjbfjX1f";
      api = {
        host = "0.0.0.0";
        port = 8443;
        ssl = {
          enabled = true;
          domain = "sasqatch.daviaaze.com";
        };
        trusted_proxies = [
          "173.245.48.0/20"
          "103.21.244.0/22"
          "103.22.200.0/22"
          "103.31.4.0/22"
          "141.101.64.0/18"
          "108.162.192.0/18"
          "190.93.240.0/20"
          "188.114.96.0/20"
          "197.234.240.0/22"
          "198.41.128.0/17"
          "162.158.0.0/15"
          "104.16.0.0/13"
          "104.24.0.0/14"
          "172.64.0.0/13"
          "131.0.72.0/22"
        ];
      };
      system = {
        sftp = {
          bind_port = 2022;
        };
        timezone = "America/Sao_Paulo";
        username = "pelican";
        user = {
          uid = 657;
          gid = 657;
          rootless = {
            enabled = true;
            container_uid = 657;
            container_gid = 657;
          };
        };
        check_permissions_on_boot = false;
        crash_detection = {
          enabled = true;
          timeout = 60;
        };
        allowed_mounts = [ ];
      };
      docker.network = {
        name = "host";
        network_mode = "host";
      };
      remote = "https://panel.daviaaze.com";
    };
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
            "*.daviaaze.com" = {
              service = "http://localhost:80";
            };
          };
          default = "http_status:404";
        };
      };
    };
    openvscode-server = {
      enable = true;
      withoutConnectionToken = true;
    };
    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.sops.secrets.cloudflare_api_token.path;
      domains = [ "sasqatch.daviaaze.com" ];
      ipv4 = true;
      ipv6 = true;
      proxied = false;
      deleteMissing = true;
    };
  };
  virtualisation = {
    docker = {
      enable = true;
    };
  };

  programs = {
    zsh = {
      enable = true;
      enableBashCompletion = true;
      autosuggestions.enable = true;
      histSize = 500;
      shellAliases = {
        "update-local" = "sudo nixos-rebuild switch --flake ~/.nixfiles";
        "update-remote" = "sudo nixos-rebuild switch --flake github:daviaaze/nixfiles";
      };
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
