{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.pelican-wings;
  pelican-wings = pkgs.callPackage ./package.nix { };

  # SSL submodule
  sslOpts = types.submodule {
    options = {
      enabled = mkOption {
        type = types.bool;
        default = false;
        description = "Enable SSL/TLS for the API";
      };
      domain = mkOption {
        type = types.str;
        default = "";
        example = "example.com";
        description = "Domain name";
      };
      cert = mkOption {
        type = types.str;
        default = "/etc/letsencrypt/live/${cfg.api.ssl.domain}/fullchain.pem";
        example = "/etc/letsencrypt/live/${cfg.api.ssl.domain}/fullchain.pem";
        description = "Path to SSL certificate file";
      };
      key = mkOption {
        type = types.str;
        default = "/etc/letsencrypt/live/${cfg.api.ssl.domain}/privkey.pem";
        example = "/etc/letsencrypt/live/${cfg.api.ssl.domain}/privkey.pem";
        description = "Path to SSL private key file";
      };
    };
  };

  # API submodule
  apiOpts = types.submodule {
    options = {
      host = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = "API binding address";
      };
      port = mkOption {
        type = types.port;
        default = 8443;
        description = "API listening port";
      };
      ssl = mkOption {
        type = sslOpts;
        default = { };
        description = "SSL configuration for the API";
      };
      upload_limit = mkOption {
        type = types.int;
        default = 256;
        description = "Maximum upload size in megabytes";
      };
      disable_remote_download = mkOption {
        type = types.bool;
        default = false;
        description = "Disable remote download";
      };
      trusted_proxies = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of trusted proxies";
      };
    };
  };

  # System submodule
  systemOpts = types.submodule {
    options = {
      root_directory = mkOption {
        type = types.str;
        default = "/var/lib/pelican";
        description = "Root directory for Pelican Wings";
      };
      log_directory = mkOption {
        type = types.str;
        default = "/var/log/pelican";
        description = "Directory for log files";
      };
      data = mkOption {
        type = types.str;
        default = "${cfg.system.root_directory}/volumes";
        description = "Path to store container volumes";
      };
      archive_directory = mkOption {
        type = types.str;
        default = "${cfg.system.root_directory}/archives";
        description = "Directory for archives";
      };
      backup_directory = mkOption {
        type = types.str;
        default = "${cfg.system.root_directory}/backups";
        description = "Directory for backups";
      };
      tmp_directory = mkOption {
        type = types.str;
        default = "${cfg.system.root_directory}/tmp";
        description = "Temporary directory";
      };
      username = mkOption {
        type = types.str;
        default = "pelican";
        description = "System username";
      };
      timezone = mkOption {
        type = types.str;
        default = "UTC";
        example = "America/Sao_Paulo";
        description = "System timezone";
      };
      user = mkOption {
        type = types.submodule {
          options = {
            rootless = mkOption {
              type = types.submodule {
                options = {
                  enabled = mkOption {
                    type = types.bool;
                    default = false;
                    description = "Enable rootless mode";
                  };
                  container_uid = mkOption {
                    type = types.int;
                    default = 0;
                    description = "Container UID";
                  };
                  container_gid = mkOption {
                    type = types.int;
                    default = 0;
                    description = "Container GID";
                  };
                };
              };
              default = { };
            };
            uid = mkOption {
              type = types.int;
              default = 985;
              description = "User ID";
            };
            gid = mkOption {
              type = types.int;
              default = 985;
              description = "Group ID";
            };
            mount_passwd = mkOption {
              type = types.bool;
              default = true;
              description = "Mount passwd file";
            };
            passwd_file = mkOption {
              type = types.str;
              default = "${cfg.system.root_directory}/passwd";
              description = "Path to passwd file";
            };
          };
        };
        default = {
          rootless = {
            enabled = false;
            container_uid = 0;
            container_gid = 0;
          };
        };
      };
      disk_check_interval = mkOption {
        type = types.int;
        default = 150;
        description = "Disk check interval in seconds";
      };
      activity_send_interval = mkOption {
        type = types.int;
        default = 60;
        description = "Activity send interval in seconds";
      };
      activity_send_count = mkOption {
        type = types.int;
        default = 100;
        description = "Number of activities to send";
      };
      check_permissions_on_boot = mkOption {
        type = types.bool;
        default = true;
        description = "Check permissions on boot";
      };
      enable_log_rotate = mkOption {
        type = types.bool;
        default = true;
        description = "Enable log rotation";
      };
      websocket_log_count = mkOption {
        type = types.int;
        default = 150;
        description = "Number of websocket logs to keep";
      };
      crash_detection = mkOption {
        type = types.submodule {
          options = {
            enabled = mkOption {
              type = types.bool;
              default = true;
              description = "Enable crash detection";
            };
            detect_clean_exit_as_crash = mkOption {
              type = types.bool;
              default = true;
              description = "Detect clean exits as crashes";
            };
            timeout = mkOption {
              type = types.int;
              default = 60;
              description = "Crash detection timeout in seconds";
            };
          };
        };
        default = { };
      };
      backups = mkOption {
        type = types.submodule {
          options = {
            write_limit = mkOption {
              type = types.int;
              default = 0;
              description = "Backup write limit (0 for unlimited)";
            };
            compression_level = mkOption {
              type = types.enum [ "best_speed" "best_compression" ];
              default = "best_speed";
              description = "Backup compression level";
            };
            remove_backups_on_server_delete = mkOption {
              type = types.bool;
              default = true;
              description = "Remove backups when server is deleted";
            };
          };
        };
        default = { };
      };
      sftp = mkOption {
        type = types.submodule {
          options = {
            bind_port = mkOption {
              type = types.port;
              default = 2022;
              description = "SFTP listening port";
            };
            bind_address = mkOption {
              type = types.str;
              default = "0.0.0.0";
              description = "SFTP binding address";
            };
            read_only = mkOption {
              type = types.bool;
              default = false;
              description = "SFTP read-only mode";
            };
          };
        };
      };
      allowed_mounts = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "List of allowed mount points";
      };
    };
  };

  # Docker configuration submodule
  dockerOpts = types.submodule {
    options = {
      network = mkOption {
        type = types.submodule {
          options = {
            interface = mkOption {
              type = types.str;
              default = "172.18.0.1";
              description = "Docker network interface";
            };
            dns = mkOption {
              type = types.listOf types.str;
              default = [ "1.1.1.1" "1.0.0.1" ];
              description = "DNS servers";
            };
            name = mkOption {
              type = types.str;
              default = "pelican_nw";
              description = "Network name";
            };
            ispn = mkOption {
              type = types.bool;
              default = false;
              description = "Is PurgeNet";
            };
            IPv6 = mkOption {
              type = types.bool;
              default = true;
              description = "Enable IPv6";
            };
            driver = mkOption {
              type = types.str;
              default = "bridge";
              description = "Network driver";
            };
            network_mode = mkOption {
              type = types.str;
              default = "pelican_nw";
              description = "Network mode";
            };
            is_internal = mkOption {
              type = types.bool;
              default = false;
              description = "Is internal network";
            };
            enable_icc = mkOption {
              type = types.bool;
              default = true;
              description = "Enable inter-container communication";
            };
            network_mtu = mkOption {
              type = types.int;
              default = 1500;
              description = "Network MTU";
            };
          };
        };
        default = { };
      };
    };
  };

  configFile = ''
    debug: ${boolToString cfg.debug}
    app_name: ${cfg.appName}
    uuid: ${cfg.uuid}
    token_id: ${cfg.tokenId}
    token: ${cfg.token}
    api:
      host: ${cfg.api.host}
      port: ${toString cfg.api.port}
      ssl:
        enabled: ${boolToString cfg.api.ssl.enabled}
        cert: ${cfg.api.ssl.cert}
        key: ${cfg.api.ssl.key}
      disable_remote_download: ${boolToString cfg.api.disable_remote_download}
      upload_limit: ${toString cfg.api.upload_limit}
      trusted_proxies: ${builtins.toJSON cfg.api.trusted_proxies}
    system:
      root_directory: ${cfg.system.root_directory}
      log_directory: ${cfg.system.log_directory}
      data: ${cfg.system.data}
      archive_directory: ${cfg.system.archive_directory}
      backup_directory: ${cfg.system.backup_directory}
      tmp_directory: ${cfg.system.tmp_directory}
      username: ${cfg.system.username}
      timezone: ${cfg.system.timezone}
      user:
        rootless:
          enabled: ${boolToString cfg.system.user.rootless.enabled}
          container_uid: ${toString cfg.system.user.rootless.container_uid}
          container_gid: ${toString cfg.system.user.rootless.container_gid}
        uid: ${toString cfg.system.user.uid}
        gid: ${toString cfg.system.user.gid}
        mount_passwd: ${boolToString cfg.system.user.mount_passwd}
        passwd_file: ${cfg.system.user.passwd_file}
      disk_check_interval: ${toString cfg.system.disk_check_interval}
      activity_send_interval: ${toString cfg.system.activity_send_interval}
      activity_send_count: ${toString cfg.system.activity_send_count}
      check_permissions_on_boot: ${boolToString cfg.system.check_permissions_on_boot}
      enable_log_rotate: ${boolToString cfg.system.enable_log_rotate}
      websocket_log_count: ${toString cfg.system.websocket_log_count}
      crash_detection:
        enabled: ${boolToString cfg.system.crash_detection.enabled}
        detect_clean_exit_as_crash: ${boolToString cfg.system.crash_detection.detect_clean_exit_as_crash}
        timeout: ${toString cfg.system.crash_detection.timeout}
      backups:
        write_limit: ${toString cfg.system.backups.write_limit}
        compression_level: ${cfg.system.backups.compression_level}
        remove_backups_on_server_delete: ${boolToString cfg.system.backups.remove_backups_on_server_delete}
    docker:
      network:
        interface: ${cfg.docker.network.interface}
        dns: ${builtins.toJSON cfg.docker.network.dns}
        name: ${cfg.docker.network.name}
        ispn: ${boolToString cfg.docker.network.ispn}
        IPv6: ${boolToString cfg.docker.network.IPv6}
        driver: ${cfg.docker.network.driver}
        network_mode: ${cfg.docker.network.network_mode}
        is_internal: ${boolToString cfg.docker.network.is_internal}
        enable_icc: ${boolToString cfg.docker.network.enable_icc}
        network_mtu: ${toString cfg.docker.network.network_mtu}
    allowed_mounts: ${builtins.toJSON cfg.system.allowed_mounts}
    remote: ${cfg.remote}
    Search:
      blacklisted_dirs: ${builtins.toJSON cfg.search.blacklisted_dirs}
      max_recursion_depth: ${toString cfg.search.max_recursion_depth}
    BlockBaseDirMount: ${boolToString cfg.blockBaseDirMount}
    allowed_origins: ${builtins.toJSON cfg.allowedOrigins}
    allow_cors_private_network: ${boolToString cfg.allowCorsPrivateNetwork}
    ignore_panel_config_updates: ${boolToString cfg.ignorePanelConfigUpdates}
  '';
in
{
  options.modules.pelican-wings = {
    enable = mkEnableOption "Enable Pelican Wings";

    debug = mkOption {
      type = types.bool;
      default = false;
      description = "Enable debug mode";
    };

    uuid = mkOption {
      type = types.str;
      example = "";
      description = "Unique identifier for this wings instance";
    };

    tokenId = mkOption {
      type = types.str;
      example = "";
      description = "Token ID for authentication";
    };

    token = mkOption {
      type = types.str;
      example = "";
      description = "Authentication token";
    };

    api = mkOption {
      type = apiOpts;
      default = { };
      description = "API configuration";
    };

    system = mkOption {
      type = systemOpts;
      default = { 
        sftp = {
          bind_port = 2022;
        };
        data = "${cfg.system.root_directory}/volumes";
       };
      description = "System configuration";
    };

    allowedMounts = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "List of allowed mount points";
    };

    remote = mkOption {
      type = types.str;
      example = "https://panel.example.com";
      description = "Remote panel URL";
    };

    appName = mkOption {
      type = types.str;
      default = "pelican";
      description = "Application name";
    };

    search = mkOption {
      type = types.submodule {
        options = {
          blacklisted_dirs = mkOption {
            type = types.listOf types.str;
            default = [ "node_modules" ".wine" "appcache" "depotcache" "vendor" ];
            description = "Directories to blacklist from search";
          };
          max_recursion_depth = mkOption {
            type = types.int;
            default = 8;
            description = "Maximum recursion depth for search";
          };
        };
      };
      default = { };
    };

    blockBaseDirMount = mkOption {
      type = types.bool;
      default = true;
      description = "Block base directory mounting";
    };

    allowedOrigins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Allowed CORS origins";
    };

    allowCorsPrivateNetwork = mkOption {
      type = types.bool;
      default = false;
      description = "Allow CORS private network";
    };

    ignorePanelConfigUpdates = mkOption {
      type = types.bool;
      default = false;
      description = "Ignore panel configuration updates";
    };

    docker = mkOption {
      type = dockerOpts;
      default = { };
      description = "Docker configuration";
    };
  };

  config = mkIf cfg.enable {
    system.activationScripts.makePelicanDir = lib.stringAfter [ "var" ] ''
      mkdir -p ${cfg.system.root_directory}
      mkdir -p ${cfg.system.tmp_directory}
      chown pelican:pelican ${cfg.system.root_directory}
      chown pelican:pelican ${cfg.system.tmp_directory}
      echo '${configFile}' > ${cfg.system.root_directory}/config.yml
    '';
    systemd.services.pelican-wings = {
      description = "Pelican Wings Daemon";
      after = [ "network-online.target" "docker.service" ];
      wants = [ "network-online.target" "docker.service" ];
      partOf = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "pelican";
        Group = "root";
        WorkingDirectory = "/var/lib/pelican";
        RuntimeDirectory = "pelican-wings";
        RuntimeDirectoryMode = "0750";
        LimitNOFILE = 4096;
        PIDFile = "/run/pelican-wings/daemon.pid";
        ExecStartPre = [
          "+${pkgs.coreutils}/bin/mkdir -p ${cfg.system.tmp_directory}"
          "+${pkgs.coreutils}/bin/chown pelican:pelican ${cfg.system.tmp_directory}"
        ];
        ExecStart = "${pelican-wings}/bin/pelican-wings --config ${cfg.system.root_directory}/config.yml";
        Restart = "always";
        RestartSec = "5s";
      };
    };

    # Create user and group
    users.users.pelican = {
      group = "root";
      isSystemUser = true;
      home = "/var/lib/pelican";
      createHome = true;
      extraGroups = [ "docker" "letsencrypt" ];
      description = "Pelican Wings daemon user";
    };

    users.groups.pelican = { };

    # Ensure the letsencrypt directory has proper permissions
    system.activationScripts.letsencryptPermissions = lib.stringAfter [ "var" ] ''
      if [ -d /etc/letsencrypt/live ]; then
        ${pkgs.acl}/bin/setfacl -R -m g:letsencrypt:rX /etc/letsencrypt/{live,archive}
      fi
    '';

    networking.firewall.allowedTCPPorts = [ cfg.api.port cfg.system.sftp.bind_port ];
  };
}
