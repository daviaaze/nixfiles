{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      btop
      python3
      screen
      neofetch
      nil
      nixpkgs-fmt
      ghostty
    ];
  };

  programs = {
    eza.enable = true;
    bat.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    starship = {
      enable = true;
      settings.add_newline = false;
    };
  };
}
