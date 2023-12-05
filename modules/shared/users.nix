{ pkgs, ... }: {
  imports = [ ];

  users.users = {
    daviaaze = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "Davi Alves de Azevedo";
      extraGroups = [ "networkmanager" "wheel" "audio" "docker" ];
    };
  };
}
