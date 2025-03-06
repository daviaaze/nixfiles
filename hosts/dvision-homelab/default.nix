{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
  ];

  sops = {
    secrets = {
      cloudflared_token = {
        owner = "cloudflared";
      };
      cloudflare_api_token = { };
      tailscale_auth_key = { };
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "dvision-homelab";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 6900 6121 5121 2456 2457 ];
      allowedTCPPortRanges = [{
        from = 25500;
        to = 25600;
      }];
    };
    networkmanager.enable = true;
  };

  modules = {
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
    cloudflare-dyndns = {
      enable = true;
      apiTokenFile = config.sops.secrets.cloudflare_api_token.path;
      domains = [ "sasqatch.daviaaze.com" ];
      ipv4 = true;
      ipv6 = false;
      proxied = false;
      deleteMissing = true;
    };
    tailscale = {
      enable = true;
      authKeyFile = config.sops.secrets.tailscale_auth_key.path;
      openFirewall = true;
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
      remotePlay.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

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
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-connections
      epiphany
      geary
      evince
      gnome-terminal
      gnome-console
    ];
  };

  xdg.portal.wlr.enable = true;

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
