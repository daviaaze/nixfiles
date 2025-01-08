{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    btop
    git
    git-lfs
    python3
    kitty
    screen
    neofetch
    nil
    nixpkgs-fmt
    vscodium
  ];

  home.sessionVariables = {
    EDITOR = "codium";
    BROWSER = "zen";
    TERMINAL = "kitty";
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
    tmux = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
  };
}
