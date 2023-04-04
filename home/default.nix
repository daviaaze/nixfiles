  { inputs, pkgs, ... }: {

  imports = [
  ]; 
  home = {
    username = "daviaaze";
    homeDirectory = "/home/daviaaze";
    stateVersion = "22.11";
    packages = with pkgs; [
      spotify
      slack
    ];
  };
  }