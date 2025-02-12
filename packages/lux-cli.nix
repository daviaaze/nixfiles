{ mkYarnPackage, makeWrapper, pulumi-bin, postgresql, ssm-session-manager-plugin, awscli2, lib, src }:
mkYarnPackage {
  pname = "luxuryescapes-cli";
  version = "1.3.3";

  src = src;

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    pulumi-bin
    postgresql
    ssm-session-manager-plugin
    awscli2
  ];

  buildPhase = ''
    runHook preBuild
    
    yarn --offline build
  '';

  postInstall = ''
      wrapProgram $out/bin/le \
        --prefix PATH : ${lib.makeBinPath [
    pulumi-bin
    ssm-session-manager-plugin
    awscli2
    postgresql
    ]}
  '';

  # Remove unnecessary phases
  doDist = false;

  meta = with lib; {
    description = "LuxuryEscapes CLI tool";
    homepage = "https://github.com/luxuryescapes/cli";
    license = licenses.mit;
    maintainers = [ ];
  };
}
