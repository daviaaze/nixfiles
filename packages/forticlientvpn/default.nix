{ stdenv
, lib
, fetchurl
, dpkg
, glibc
, autoPatchelfHook
, libredirect
, makeWrapper
, gzip
, gnutar
, libappindicator
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "FortiClient VPN";
  version = "7.2.2.0753";

  src = fetchurl {
    url = "https://filestore.fortinet.com/forticlient/forticlient_vpn_${version}_amd64.deb";
    sha256 = "sha256-nsbwfaEBQkF/FUu+g6JHuEIuBd/VBXZlJ7A5oQiYWL8=";
  };


  nativeBuildInputs = [ dpkg glibc libappindicator autoPatchelfHook makeWrapper ];

  buildInputs = [ ];

  unpackPhase = ''
    runHook preUnpack

    dpkg --vextract $src ./forticlient-src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r forticlient-src/* "$out"

    # Flatten /usr and manually merge lib/ and usr/lib/, since mv refuses to.
    mv "$out/lib" "$out/orig_lib"
    mv "$out/usr/"* "$out/"
    mkdir -p "$out/lib/systemd/system/"
    mv "$out/orig_lib/systemd/system/"* "$out/lib/systemd/system/"
    rmdir "$out/orig_lib/systemd/system"
    rmdir "$out/orig_lib/systemd"
    rmdir "$out/orig_lib"
    rmdir "$out/usr"

    for f in "$out/lib/systemd/system/"*.service \
             "$out/share/applications/"*.desktop; do
        substituteInPlace "$f" \
            --replace "/usr/" "$out/"
    done

    for p in "$out/bin/forticlient" "$out/bin/GCFFlasher_internal.bin"; do
        wrapProgram "$p" \
            --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
            --set NIX_REDIRECTS "/usr/share=$out/share:/usr/bin=$out/bin" \
            --prefix PATH : "${lib.makeBinPath [ gzip gnutar ]}"
    done

    runHook postInstall
  '';

  passthru = {
    tests = { inherit (nixosTests) forticlientvpn; };
  };

  meta = with lib; {
    description = "";
    homepage = "";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [  ];
    mainProgram = "FortiClient VPN";
  };
}
