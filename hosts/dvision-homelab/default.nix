{ pkgs, inputs, config, ... }: {
  imports = [
    inputs.chaotic.nixosModules.default
    ./hardware.nix
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs.inputs = inputs;
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.vscode-server.homeModules.default
        ];
        users.daviaaze = {
          sops = {
            age.keyFile = "/home/daviaaze/.config/sops/age/keys.txt"; # must have no password!
            # It's also possible to use a ssh key, but only when it has no password:
            #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
            defaultSopsFile = ../../secrets/secrets.yaml;
          };
          imports = [
            ../../home/minimal.nix
          ];
        };
      };
    }
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

  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "23.11";
}
