{ lib
, addDriverRunpath
, config
, fetchFromGitHub
, substituteAll
, triton
, triton-llvm
, cudaSupport ? config.cudaSupport
, rocmSupport ? config.rocmSupport
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
  backends = [ "cpu" ]
    ++ lib.optional cudaSupport "nvidia"
    ++ lib.optional rocmSupport "amd";
  backendsTuple = builtins.concatStringsSep ";" backends;
in
triton'.overridePythonAttrs (previousAttrs: {
  # version = "3.2.0-unstable-2024-12-19";

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "triton-cpu";
    rev = "8390fa2e092bfc8824f78edb344d2142b6818c06";
    hash = "sha256-eXWCcwXUpLk7VegrBmwYBSzZ4Fweouc2/zm5H0Cbe7k=";
    # for sleef
    fetchSubmodules = true;
  };

  patches = [
    (substituteAll {
      src = ./0001-_build-allow-extra-cc-flags.patch;
      ccCmdExtraFlags = "-Wl,-rpath,${addDriverRunpath.driverLink}/lib";
    })
    ./0002-disable-bin.patch
    ./0003-backends-tuple.patch
  ];

  postPatch = "";

  env = previousAttrs.env or { } // {
    LLVM_INCLUDE_DIRS = "${lib.getDev triton-llvm'}";
    LLVM_LIBRARY_DIR = "${lib.getLib triton-llvm'}";
    LLVM_SYSPATH = "${triton-llvm'}";
    TRITON_APPEND_CMAKE_ARGS = "-DTRITON_CODEGEN_BACKENDS=${backendsTuple}";
    TRITON_BACKENDS_TUPLE = backendsTuple;
  };
})
