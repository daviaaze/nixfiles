{ inputs, pkgs, ... }: {
  imports = [
    ./features/desktop
    ./features/gaming
    ./features/work
    ./features/cli
    ./programs
  ];

  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = true;

    # Core packages that don't fit into specific categories
    packages = with pkgs; [
      spotify
      stremio
      trayscale
      discord-canary
      discord
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };

  programs.home-manager.enable = true;

  # Global GTK configuration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
