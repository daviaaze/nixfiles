{ ... }: {
  imports = [
    ./locale.nix
    ./users.nix
  ];

  # Configure console keymap
  console.keyMap = "br-abnt2";

  nixpkgs.config.permittedInsecurePackages = [
    "electron-28.3.3"
  ];
}
