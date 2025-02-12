# Common Nix settings shared across configurations
{ ... }: {
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/daviaaze/.nixfiles";
  };
  nix = {
    settings = {
      trusted-users = [ "root" "wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };
}
