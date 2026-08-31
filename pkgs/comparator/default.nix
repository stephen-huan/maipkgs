{ lib
, fetchFromGitHub
, fetchpatch2
, leanPackages
, replaceVars
, git
, landrun
}:

leanPackages.buildLakePackage (finalAttrs: {
  version = "4.30.0";
  pname = "comparator";
  leanPackageName = "Comparator";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "comparator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oOo/FUUwcVErRzhXSDNinulxNy1ywWBXA8HnDSURzPg=";
  };

  patches = [
    (replaceVars ./0001-build-Main.lean-hardcode-git.patch {
      inherit git;
    })
    # https://github.com/leanprover/comparator/pull/55
    (fetchpatch2 {
      name = "remove-lean4checker.patch";
      url = "https://github.com/leanprover/comparator/commit/3c972ca2d4e3fb5f336bd2c153e3bd744913b714.patch?full_index=1";
      hash = "sha256-LqxtKbjtAK+OTpKBCp3Qo+tXrDm4k/GTQ3TuM5Cp0eE=";
    })
  ];

  leanDeps = with leanPackages; [ lean4export ];

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
