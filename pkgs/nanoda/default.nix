{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda";
  version = "0.3.2-unstable-2026-08-25";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    rev = "05055695879dfebb6628a67da88ceca6cd6b0421";
    hash = "sha256-VDypZX82Q192kHWs17cfdXIGfqfqMXklehT/MCqbhyg=";
  };

  cargoHash = "sha256-nROCcjNZjvtnWDnsDLUMhDjIGZ2fZFUZIq/lOWIJiRg=";

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
