{ pkgs, inputs, ... }: {
  imports = [
    ./features/cli
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = true;
    packages = [ pkgs.dconf ];
  };

  programs = {
    home-manager.enable = true;
    micro.enable = true;
  };

  services.vscode-server = {
    enable = true;
    installPath = "$HOME/.vscodium-server";
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
