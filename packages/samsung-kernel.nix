{ stdenv, lib, fetchFromGitHub, kernel }:
stdenv.mkDerivation rec {
  pname = "samsung-galaxybook";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "daviaaze";
    repo = "samsung-galaxybook-extras";
    rev = "60d6c9397874605861c22e674510bad849b3a4f4";
    hash = "sha256-GzXfz2DOORUJEeAsvGevNyQNRaCK5+wS1PQ65Xu6NhY=";
  };

  hardeningDisable = [ "pic" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;                  # 2

 buildPhase = ''
    make -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build \
      M=$(pwd) \
      modules
  '';

    installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/extra
    find . -name '*.ko' -exec cp {} $out/lib/modules/${kernel.modDirVersion}/extra \;
  '';

  makeFlags = kernel.makeFlags ++ [
    "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KERNEL_SRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
  ];

  meta = {
    description = "Samsung Galaxy Book series extras Linux platform driver";
    homepage = "https://github.com/daviaaze/samsung-galaxybook-extras";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}