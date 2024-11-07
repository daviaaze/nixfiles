{ inputs, pkgs, ... }: {
  imports = [
    inputs.nur.hmModules.nur
    ./zsh.nix
    ./services.nix
    ./gnome.nix
    ./work.nix
    ./gaming.nix
    ./wayland.nix
    ./activitywatch.nix
  ];
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "23.11";
    packages = with pkgs; [
      spotify
      stremio
      trayscale
      inputs.zen-browser.packages."${system}".default
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
