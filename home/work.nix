{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    inputs.luxuryescapes-cli.packages.${system}.default
    slack
    teams-for-linux
    jetbrains.datagrip
    brave
    openfortivpn
  ];
}
