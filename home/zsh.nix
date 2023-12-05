{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    btop
    micro
    git
    neofetch
  ];

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
      settings = {
        add_newline = false;
        # format = "$shell$username$hostname$nix_shell$directory$git_branch$git_commit$git_status$[❯](bold gray)$node[❯](bold blue)[❯](bold green)";
        # nix_shell = {
        #   symbol = "nix";
        #   format = "[<$symbol> ]($style)";
        #   style = "blue bold";
        # };
      };
    };
    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      historySubstringSearch.enable = true;
      shellAliases = {
        update = "sudo nixos-rebuild switch --upgrade --flake github:daviaaze/nixfiles";
        update-local = "sudo nixos-rebuild switch --upgrade --flake ~/.nixfiles";
        update-flake = "sudo nix flake update ~/.nixfiles;";
        ls = "exa --color=always --icons";
        cat = "bat";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "Aloxaf/fzf-tab"; }
        ];
      };
      initExtra = ''
        ${pkgs.neofetch}/bin/neofetch
      '';
    };
  };
}
