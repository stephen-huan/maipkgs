{ lib
, fetchFromGitHub
, leanPackages
}:

leanPackages.buildLakePackage (finalAttrs: {
  version = "4.27.0-rc1-unstable-2025-12-21";
  pname = "lean4checker";
  # lowercase in its own lakefile.toml but uppercase in comparator's
  leanPackageName = "Lean4Checker";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4checker";
    rev = "b7398199245524275543dec6113229c9bb4902e5";
    hash = "sha256-cxdEI6KBjtA6TGsAzgLqAkuzkzabw4daeM/KXkzOPG0=";
  };

  doCheck = true;

  checkPhase = ''
    lake test
  '';

  meta = with lib; {
    description = "Replay the environment for a given Lean module";
    homepage = "https://github.com/leanprover/lean4checker";
    license = licenses.asl20;
    mainProgram = "lean4checker";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
