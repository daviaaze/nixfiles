{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    inputs.luxuryescapes-cli.packages.${system}.default
    gh
    slack
    teams-for-linux
    jetbrains.datagrip
    openfortivpn
    postman
    (pkgs.callPackage ../packages/openfortivpn-webviewer.nix { })
    ffmpeg
  ];
}
