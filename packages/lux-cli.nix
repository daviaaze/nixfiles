{ fetchFromGitHub, mkYarnPackage, electron_28, makeWrapper, pulumi-bin, postgresql, ssm-session-manager-plugin, awscli2, lib, }:
mkYarnPackage rec {
  pname = "luxuryescapes-cli";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "lux-group";
    repo = "cli";
    rev = "main";
  };

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
        --prefix PATH : ${lib.makeBinPath ([
    pulumi-bin
    ssm-session-manager-plugin
    awscli2
    postgresql
    ])}
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
