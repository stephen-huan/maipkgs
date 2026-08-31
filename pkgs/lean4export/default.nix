{ lib
, fetchFromGitHub
, leanPackages
}:

leanPackages.buildLakePackage (finalAttrs: {
  version = "4.30.0";
  pname = "lean4export";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4export";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kg0XW1HTJplBHznI4FM9KxSZIuQ/5P0IILp3FjDRXJA=";
  };

  # force Export.Parse target for comparator
  buildTargets = [ "lean4export" "Export.Parse:c.o.export" ];

  doCheck = true;

  checkPhase = ''
    lake test
  '';

  meta = with lib; {
    description = "Plain-text declaration export for Lean 4";
    homepage = "https://github.com/leanprover/lean4export";
    license = licenses.asl20;
    mainProgram = "lean4export";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
