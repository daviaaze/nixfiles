{ ... }: {
  imports = [
    ./shared
    ./pelican-panel
    ./pelican-wings
    ./cloudflared
    ./nginx
    ./beszel.nix
  ];
}
