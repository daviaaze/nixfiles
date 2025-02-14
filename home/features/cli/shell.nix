{ pkgs, ... }: {
  home = {
    packages = with pkgs; [
      btop
      python3
      screen
      neofetch
      nil
      nixpkgs-fmt
    ];
  };
}
