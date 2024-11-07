{ pkgs, ... }: {
  home.packages = with pkgs; [
    prismlauncher
    moonlight-qt
    bottles
  ];
}
