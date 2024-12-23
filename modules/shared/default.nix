_ : {
  imports = [
    ./locale.nix
    ./users.nix
    ./nix.nix
  ];

  # Configure console keymap
  console.keyMap = "br-abnt2";
}
