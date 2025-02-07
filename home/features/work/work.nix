{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    gh
    slack
    teams-for-linux
    jetbrains.datagrip
    openfortivpn
    postman
    code-cursor
    (pkgs.callPackage ../../../packages/openfortivpn-webviewer.nix { })
    
  ];
}
