{ lib
, fetchFromGitHub
, fetchpatch2
, triton
, triton-llvm
}:
let
  triton-llvm' = triton-llvm.overrideAttrs {
    src = fetchFromGitHub {
      owner = "llvm";
      repo = "llvm-project";
      rev = "86b69c31642e98f8357df62c09d118ad1da4e16a";
      hash = "sha256-W/mQwaLGx6/rIBjdzUTIbWrvGjdh7m4s15f70fQ1/hE=";
    };
    patches = [ ];
  };
  triton' = triton.override {
    llvm = triton-llvm';
  };
in
triton'.overridePythonAttrs (previousAttrs: {
  version = "3.2.0-unstable-2024-12-23";

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton-cpu";
    rev = "daa7eb01e1f3fe60d0e0b9a643886f32d3c3ffe7";
    hash = "sha256-AsAUP1jakVeBwk7I+zHesuLftkN7d12MWNHROZSPlgc=";
    # for sleef
    fetchSubmodules = true;
  };

  patches = [
    (fetchpatch2 {
      name = "cudaless.patch";
      url = "https://github.com/triton-lang/triton/pull/5492.patch";
      hash = "sha256-Ww33nSJRmEyX+bh6ryastsHCMR6XefUGb0y/qof+ITA=";
    })
  ];

  postPatch = "";

  env = previousAttrs.env or { } // {
    LLVM_INCLUDE_DIRS = "${lib.getDev triton-llvm'}";
    LLVM_LIBRARY_DIR = "${lib.getLib triton-llvm'}";
    LLVM_SYSPATH = "${triton-llvm'}";
  };
})
