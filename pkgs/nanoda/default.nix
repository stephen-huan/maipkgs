{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YKoexQz/2Z+sxdNtJfNvkZRbLFff1SXaWRzTcrU9Oz4=";
  };

  cargoHash = "sha256-Low43L/Yd/OLjfE+9om1gztfrdFhZptjJJEZg92m3xg=";

  strictDeps = true;
  __structuredAttrs = true;

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
