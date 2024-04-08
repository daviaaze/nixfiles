{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    inputs.luxuryescapes-cli.packages.${system}.default
    slack
    jetbrains.datagrip
  ];
}
