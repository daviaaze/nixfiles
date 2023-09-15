{
  description = "My system configuration in flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    fufexan.url = "github:fufexan/dotfiles";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, hyprland, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        nixpkgs-fmt
        nil
      ];
    };
    nixosConfigurations.dvision-desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs.inputs = inputs;
        modules = [
          ./modules
          ./modules/dvision-desktop
          hyprland.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            programs.hyprland.enable = true;
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs.inputs = inputs;
              users.daviaaze.imports = [
                ./home
                hyprland.homeManagerModules.default
              ];
            };
          }
        ];
    };
  };
}
