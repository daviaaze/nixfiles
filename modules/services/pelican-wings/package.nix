{ stdenv, fetchurl, docker, gnutar }:

stdenv.mkDerivation rec {
  pname = "pelican-wings";
  version = "v1.0.0-beta9";

  src = fetchurl {
    url = "https://github.com/pelican-dev/wings/releases/download/${version}/wings_linux_amd64";
    hash = "sha256-YaS1bthNSeWXH5drc2yensRqsRAOa2VXvivJOaPybqc=";
  };

  buildInputs = [ docker gnutar ];

  phases = [ "installPhase" ];

  installPhase = ''
    install -D $src $out/bin/pelican-wings
  '';
}
