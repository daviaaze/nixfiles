{ pkgs, ... }: {
  imports = [
    ./zsh.nix
    ./services.nix
    ./gnome.nix
    ./gaming.nix
    ./wayland.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = true;
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
