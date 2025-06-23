{ lib
, fetchFromGitHub
, fetchpatch2
, triton
, triton-llvm
}:
let
  triton-llvm' = triton-llvm.overrideAttrs (previousAttrs: {
    src = fetchFromGitHub {
      owner = "llvm";
      repo = "llvm-project";
      rev = "adba14acea99cc6a17d837763a3248c9d4a2fadf";
      hash = "sha256-HWSgjTiP0mdrhbWfMJQ5B5y8+S+Brnm0J0CUPNsX9zM=";
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
  version = "3.3.0-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton-cpu";
    rev = "e60f448f8f197073b75d6d3e77347414a5db3ee7";
    hash = "sha256-y+CehczipnRTf5EylpEiLDGcim9M3hkjXHVESOsJ/oI=";
    # for sleef
    fetchSubmodules = true;
  };

  patches = [ ];

  env = previousAttrs.env or { } // {
    LLVM_INCLUDE_DIRS = "${lib.getDev triton-llvm'}";
    LLVM_LIBRARY_DIR = "${lib.getLib triton-llvm'}";
    LLVM_SYSPATH = "${triton-llvm'}";
  };
})
