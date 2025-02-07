{
  description = "My system configuration in flakes";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    luxuryescapes-cli.url = "path:/home/daviaaze/Projects/Lux/cli";
    zen-browser.url = "github:daviaaze/zen-browser-flake";
  };
  outputs = { self, nixpkgs, chaotic, home-manager, vscode-server, lanzaboote, sops-nix, flake-utils, ... }@inputs:
    let
      mkSystem = system: hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          };
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = true;
              allowBroken = true;
              allowInsecure = true;
              permittedInsecurePackages = [
                "electron-28.3.3"
              ];
            };
          };
          modules = [
            ./modules
            ./hosts/${hostname}
            lanzaboote.nixosModules.lanzaboote
            vscode-server.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            {
              sops = {
                defaultSopsFile = ./secrets/secrets.yaml;
                defaultSopsFormat = "yaml";
                age.keyFile = "/home/daviaaze/.config/sops/age/keys.txt";
                secrets.daviaaze_password.neededForUsers = true;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        dvision-thinkbook = mkSystem "x86_64-linux" "dvision-thinkbook";
        dvision-homelab = mkSystem "x86_64-linux" "dvision-homelab";
      };
    };
}
