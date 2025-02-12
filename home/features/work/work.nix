{ pkgs, inputs, config, ... }: {
  home.packages = with pkgs; [
    gh
    slack
    teams-for-linux
    jetbrains.datagrip
    openfortivpn
    postman
    code-cursor
    (pkgs.callPackage ../../../packages/openfortivpn-webviewer.nix { })
    (pkgs.callPackage ../../../packages/lux-cli.nix { src = inputs.lux-cli; npm_token_path = config.sops.secrets.work_npm_token.path; })
  ];
}
