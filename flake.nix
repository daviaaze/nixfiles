{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      dvision = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (import ./configuration.nix)
        ];
      };
    };
  };
}
