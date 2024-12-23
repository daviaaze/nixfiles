{ lib, config, ... }:
with lib;
let
  cfg = config.modules.nginx;
in
{
  imports = [
    ./modules/pelican-panel.nix
    ./modules/beszel.nix
  ];

  options.modules.nginx = {
    enable = mkEnableOption "Enable nginx";

    domainName = mkOption {
      type = types.str;
      default = "daviaaze.com";
      description = ''
        The domain name to use for the nginx server.
      '';
    };

    acmeEmail = mkOption {
      type = types.str;
      default = "daviaaze@gmail.com";
      description = ''
        The email address to use for ACME certificates.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      # Add recommended proxy settings
      recommendedProxySettings = true;
    };

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
