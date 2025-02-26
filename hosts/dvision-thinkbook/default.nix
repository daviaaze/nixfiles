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
        sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
        ];
        users.daviaaze = {
          sops = {
            age.keyFile = "/home/daviaaze/.config/sops/age/keys.txt"; # must have no password!
            # It's also possible to use a ssh key, but only when it has no password:
            #age.sshKeyPaths = [ "/home/user/path-to-ssh-key" ];
            defaultSopsFile = ../../secrets/secrets.yaml;
            secrets.work_npm_token = { };
          };
          imports = [
            ../../home
          ];
        };
      };
    }
  ];

  networking.hostName = "dvision-thinkbook";

  services = {
    pipewire.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    power-profiles-daemon.enable = true;
    thermald.enable = true;
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
      trustedInterfaces = [ "br-8ee421ae204e" ];
    };
  };

  programs = {
    zsh.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment = {
    systemPackages = with pkgs; [
      direnv
      git
      vulkan-tools
      openssl
      bitwarden-desktop
    ];
    pathsToLink = [ "/share/zsh" ];
    shells = [ pkgs.zsh ];
  };

  # Enable the GNOME Desktop Environment.
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  time.hardwareClockInLocalTime = true;

  environment.gnome.excludePackages = with pkgs; [
    # for packages that are pkgs.*
    gnome-tour
    gnome-connections
    # for packages that are pkgs.gnome.*
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-terminal
    gnome-console
  ];

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "br";
    xkb.variant = "";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      vaapiIntel
      intel-media-driver
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  system.stateVersion = "23.11";
}
