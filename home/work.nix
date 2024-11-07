{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    inputs.luxuryescapes-cli.packages.${system}.default
    pulumi
    gh
    slack
    teams-for-linux
    jetbrains.datagrip
    openfortivpn
    postman
    shotcut
    ffmpeg
  ];
}
