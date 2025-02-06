{ pkgs, config, ... }: {
  config.sops.secrets.daviaaze_password.neededForUsers = true;
  config.users.users = {
    daviaaze = {
      isNormalUser = true;
      shell = pkgs.zsh;
      description = "Davi Alves de Azevedo";
      hashedPasswordFile = config.sops.secrets.daviaaze_password.path;
      extraGroups = [ "networkmanager" "wheel" "audio" "docker" "plugdev" ];
    };
  };
}
