{ lib
, fetchFromGitHub
, leanPackages
, replaceVars
, git
, landrun
}:

leanPackages.buildLakePackage (finalAttrs: {
  version = "4.29.0";
  pname = "comparator";
  leanPackageName = "Comparator";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "comparator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Im6qHUxcH8Bu1Uppaex+a7vNiP5NI65p90er6dlNNSE=";
  };

  patches = [
    (replaceVars ./0001-build-Main.lean-hardcode-git.patch {
      inherit git;
    })
  ];

  leanDeps = with leanPackages; [ lean4checker lean4export ];

  doCheck = true;

  nativeCheckInputs = [
    landrun
    leanPackages.lean4export
  ];

  checkPhase = ''
    lean --run runtests.lean
  '';

  meta = with lib; {
    description = "Trustworthy judge for Lean proofs";
    homepage = "https://github.com/leanprover/comparator/";
    license = licenses.asl20;
    mainProgram = "comparator";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
