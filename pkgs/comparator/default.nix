{ lib
, fetchFromGitHub
, leanPackages
, git
, landrun
}:

leanPackages.buildLakePackage (finalAttrs: {
  version = "4.29.0";
  pname = "comparator";
  leanPackageName = "Comparator";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "comparator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Im6qHUxcH8Bu1Uppaex+a7vNiP5NI65p90er6dlNNSE=";
  };

  patches = [
    ./0001-build-Main.lean-hardcode-git.patch
  ];

  postPatch = ''
    substituteInPlace Main.lean \
      --subst-var-by git "${lib.getExe git}"
  '';

  leanDeps = with leanPackages; [ lean4checker lean4export ];

  strictDeps = true;
  __structuredAttrs = true;

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
