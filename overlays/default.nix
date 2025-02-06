_: {
  nixpkgs.overlays.default =
    final: prev: {
      # Custom packages
      openfortivpn-webviewer = final.callPackage ../packages/openfortivpn-webviewer.nix { };
      ideapad-laptop-tb = final.callPackage ../packages/ideapad-laptop-tb.nix { };
      pano = final.callPackage ../packages/pano.nix { };
      samsung-kernel = final.callPackage ../packages/samsung-kernel.nix { };
    };
}
