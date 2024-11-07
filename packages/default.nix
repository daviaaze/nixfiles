let

  nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/unstable";

  pkgs = import nixpkgs { config = {}; overlays = []; };

in

{

  hello = pkgs.callPackage ./hello.nix { };

}