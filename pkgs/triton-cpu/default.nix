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
  version = "3.2.0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton-cpu";
    rev = "dc8dfb6d28c4bc7cc83a7eb5defd1279ff093d4c";
    hash = "sha256-fixlHv/WZ+hvAHIaS5R+pDFawtufvRI7fI3a1CG536M=";
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
