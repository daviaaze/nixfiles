{
  stdenv,
  gsound,
  libgda6,
  lib,
  fetchzip,
  substituteAll,
  buildPackages,
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-extension-pano";
  version = "23-alpha3";
  src = fetchzip {
    url = "https://github.com/oae/gnome-shell-pano/releases/download/v${version}/pano@elhan.io.zip";
    hash = "sha256-LYpxsl/PC8hwz0ZdH5cDdSZPRmkniBPUCqHQxB4KNhc=";
    stripRoot = false;
  };
  patches = [
    (substituteAll {
      src = ./pano_at_elhan.io.patch;
      inherit gsound libgda6;
    })
  ];

  nativeBuildInputs = [ buildPackages.glib ];

  buildPhase = ''
    runHook preBuild
    if [ -d schemas ]; then
      glib-compile-schemas --strict schemas
    fi
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/pano@elhan.io
    runHook postInstall
  '';
  meta = {
    description = "Next-gen Clipboard manager for Gnome Shell";
    homepage = "https://github.com/oae/gnome-shell-pano";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
  passthru = {
    extensionPortalSlug = "pano";
    extensionUuid = "pano@elhan.io";
  };
}