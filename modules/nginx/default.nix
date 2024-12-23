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
      
      # Global nginx configuration
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;

      # Default virtual host for undefined domains
      virtualHosts."_" = {
        default = true;
        listen = [{ port = 80; addr="0.0.0.0"; }];
        locations."/" = {
          return = "404";
          extraConfig = ''
            add_header Content-Type text/plain;
          '';
        };
      };
    };

    # Open ports in the firewall.
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
