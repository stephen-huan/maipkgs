{ lib
, fetchFromGitHub
, fetchpatch2
, triton
, triton-llvm
}:
let
  triton-llvm' = (triton-llvm.override {
    llvmProjectsToBuild = [ "mlir" "llvm" "lld" ];
  }).overrideAttrs (previousAttrs: {
    src = fetchFromGitHub {
      owner = "llvm";
      repo = "llvm-project";
      rev = "a66376b0dc3b2ea8a84fda26faca287980986f78";
      hash = "sha256-7xUPozRerxt38UeJxA8kYYxOQ4+WzDREndD2+K0BYkU=";
    };
    patches = [
      # https://github.com/NixOS/nixpkgs/pull/392651
      (fetchpatch2 {
        name = "llvm-exegesis-timeout.patch";
        url = "https://github.com/llvm/llvm-project/pull/132861.patch";
        hash = "sha256-u3xjuiyQi8M82n/0/t6/Baeg+KdQoSnxRkHrPxY4DTk=";
      })
    ];
    cmakeFlags = previousAttrs.cmakeFlags or [ ] ++ [
      # takes a lot of memory
      "-DLLVM_PARALLEL_LINK_JOBS=4"
      "-DLLVM_PARALLEL_TABLEGEN_JOBS=4"
    ];
  });
  triton' = triton.override {
    llvm = triton-llvm';
  };
in
triton'.overridePythonAttrs (previousAttrs: {
  version = "3.2.0-unstable-2025-01-13";

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton-cpu";
    rev = "3b6a8b70cb2184acec5aa4a383e0147959e1001b";
    hash = "sha256-VTPikYn35jErnRWT6d/i5LI6aQsxkm6rqEgqPi80SJ4=";
    # for sleef
    fetchSubmodules = true;
  };

  patches = [ ];

  postPatch = "";

  env = previousAttrs.env or { } // {
    LLVM_INCLUDE_DIRS = "${lib.getDev triton-llvm'}";
    LLVM_LIBRARY_DIR = "${lib.getLib triton-llvm'}";
    LLVM_SYSPATH = "${triton-llvm'}";
  };
})
