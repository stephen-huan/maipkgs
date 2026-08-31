{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda";
  version = "0.3.2-unstable-2026-06-03";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    rev = "f58f2f6d535e189a40fcb02ede8eb95f97a92d37";
    hash = "sha256-N/HRosc3/JHCjhsDRn5n0LpdTOQDj0SxDM/w4KuGKjk=";
  };

  cargoHash = "sha256-mJ0/8WnzwRaH5SUeFWDJInKvg4EmdYyL4g01EIE21OI=";

  doCheck = true;

  checkFlags = [
    # failed to open configuration file (no such file or directory)
    "--skip=tests::declar::aesop_goal_unsafe"
    "--skip=tests::declar::mutual_def"
    "--skip=tests::natlit::e_nat_tests"
    "--skip=tests::pretty_printer::pp_prelude"
    "--skip=tests::stringlit::string_lit_tests"
    "--skip=tests::util::check_prelude"
  ];

  meta = with lib; {
    description = "External type checker for the Lean theorem prover";
    homepage = "https://github.com/ammkrn/nanoda_lib/";
    license = lib.licenses.asl20;
    mainProgram = "nanoda_bin";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
