{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nanoda";
  version = "0.4.19";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ammkrn";
    repo = "nanoda_lib";
    # https://github.com/leanprover/lean4/blob/v{version}/src/CMakeLists.txt
    rev = "831ba4e661ab5af55a6b1dcf69fa86c0f81f1332";
    hash = "sha256-gp8Aul2AyRh926mdmQbNcpqJ/FNzbTmA4DJUHjrc73s=";
  };

  cargoHash = "sha256-BH7GdzOWBPB4cWOSQ1Dhr4XMKVqNeVmG9F9HH5UZuhk=";

  meta = with lib; {
    description = "External type checker for the Lean theorem prover";
    homepage = "https://github.com/ammkrn/nanoda_lib";
    license = lib.licenses.asl20;
    mainProgram = "nanoda_bin";
    maintainers = with maintainers; [ stephen-huan ];
  };
})
