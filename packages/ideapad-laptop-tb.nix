{ stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation {
  name = "ideapad-laptop-tb-${kernel.version}";

  passthru.moduleName = "ideapad-laptop-tb";

  hardeningDisable = [ "pic" ];

  src = fetchFromGitHub {
    owner = "ferstar";
    repo = "ideapad-laptop-tb";
    rev = "dc534d7d627901541c5119ff90024e9d8347ec70";
    hash = "sha256-Lq61QlpMjbWxyg/fldBKZGNKP+Z6Rd6tC5WcrNP/Q8A=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  buildFlags = [
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
  ];

  installPhase = ''
    install -D ideapad-laptop-tb.ko $out/lib/modules/${kernel.modDirVersion}/misc/ideapad-laptop-tb.ko
  '';
}
