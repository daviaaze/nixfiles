# Common Nix settings shared across configurations
{ config, ... }: {
  nix = {
    settings = {
      trusted-users = [ "root" "wheel" ];
      keep-outputs = true;
      keep-derivations = true;
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      secret-key-files = config.sops.secrets.nix_access_tokens.path;

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
