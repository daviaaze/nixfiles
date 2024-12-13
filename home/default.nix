{ inputs, pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./services.nix
    ./gnome.nix
    ./work.nix
    ./gaming.nix
    ./wayland.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = true;
    
    packages = with pkgs; [
      spotify
      stremio
      trayscale
      discord-canary
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };

  programs = {
    home-manager.enable = true;
  };

  # Properly handle GTK themes under Wayland
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };
}
