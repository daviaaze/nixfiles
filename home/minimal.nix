{ pkgs, inputs, ... }: {
  imports = [
    ./features/cli
    inputs.vscode-server.homeManagerModules.vscode-server
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    enableNixpkgsReleaseCheck = true;
  };

  programs = {
    home-manager.enable = true;
    micro.enable = true;
  };
  services.vscode-server = {
    enable = true;
    installPath = "$HOME/.vscode-oss";
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
