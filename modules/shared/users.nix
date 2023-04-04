{ pkgs, ... }: {
  imports = [];
  
  users.users = {
    daviaaze = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "Davi Alves de Azevededo";
      extraGroups = [ "networkmanager" "wheel" "audio" ];
    };
  };
}