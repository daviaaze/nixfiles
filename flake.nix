{
  description = "My system configuration in flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    fufexan.url = "github:fufexan/dotfiles";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    luxuryescapes-cli.url = "path:/home/daviaaze/Projects/Lux/cli";
    zen-browser.url = "github:daviaaze/zen-browser-flake";
  };
  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs:
    {
      nixosConfigurations.dvision-notebook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./modules
          ./modules/dvision-notebook
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.inputs = inputs;
              users.daviaaze.imports = [
                ./home
              ];
            };
          }
        ];
      };
    };
}
