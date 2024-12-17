{
  description = "My system configuration in flakes";
  inputs = {
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.1";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    luxuryescapes-cli.url = "path:/home/daviaaze/Projects/Lux/cli";
    zen-browser.url = "github:daviaaze/zen-browser-flake";
  };
  outputs = { self, nixpkgs, chaotic, home-manager, lanzaboote, ... }@inputs:
    {
      nixosConfigurations.dvision-thinkbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./modules
          ./modules/dvision-thinkbook
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
          chaotic.nixosModules.default
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
