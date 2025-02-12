{ pkgs, config, ... }: {
  home.packages = with pkgs; [
    btop
    git
    git-lfs
    python3
    screen
    neofetch
    nil
    nixpkgs-fmt
    vscodium
    micro
  ];

  sops = {
    secrets = {
      work_npm_token = { };
      github_token = { };
    };
  };

  home.sessionVariables = {
    EDITOR = "micro";
    BROWSER = "zen";
    TERMINAL = "ghostty";
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
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        update = "sudo nixos-rebuild switch --upgrade --flake github:daviaaze/nixfiles";
        update-local = "nh os switch";
        test-local = "sudo nixos-rebuild test --flake ~/.nixfiles";
        update-flake = "sudo nix flake update ~/.nixfiles;";
        ls = "exa --color=always --icons";
        cat = "bat";
        setup-vpn = "openfortivpn-webview vpn.luxuryescapes.com:10443 | grep -o 'SVPNCOOKIE=.*' | cut -d'=' -f2- | sudo openfortivpn -c ~/.openfortivpn/config --cookie-on-stdin";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "Aloxaf/fzf-tab"; }
          { name = "zsh-users/zsh-history-substring-search"; }
          { name = "plugins/git"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/gh"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/heroku"; tags = [ "from:oh-my-zsh" ]; }
          { name = "plugins/yarn"; tags = [ "from:oh-my-zsh" ]; }
        ];
      };
      initExtra = ''
        export NPM_TOKEN=$(cat ${config.sops.secrets.work_npm_token.path})
        export GITHUB_TOKEN=$(cat ${config.sops.secrets.github_token.path})
        ${pkgs.lib.getExe pkgs.fastfetch}
      '';
    };
    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };
  };
}
