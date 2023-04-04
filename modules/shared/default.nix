{ pkgs, ... }: {
  imports = [
    ./locale.nix
    ./users.nix
  ];

  # Configure console keymap
  console.keyMap = "br-abnt2";
}