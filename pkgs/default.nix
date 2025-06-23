{ pkgs }:

let
  inherit (pkgs.config) cudaSupport rocmSupport;
  gpuSupport = cudaSupport || rocmSupport;
in
{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { };
  python3Packages = pkgs.python312Packages.overrideScope (final: prev: {
    blosc2 = prev.blosc2.overridePythonAttrs { doCheck = false; };
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    dppy = final.callPackage ./dppy { };
    gpjax = final.callPackage ./gpjax { };
    # has a tendancy to oom, even with a small number of cores
    jax =
      if gpuSupport
      then prev.jax.overridePythonAttrs { doCheck = false; }
      else prev.jax;
    jax-triton = final.callPackage ./jax-triton { };
    # not actually changing any dependencies, only in tests
    keras = prev.keras.overridePythonAttrs { doCheck = false; };
    kernels = final.callPackage ./kernels { };
    mugrade = final.callPackage ./mugrade { };
    # not actually changing any dependencies, only in tests
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    # long build, only in tests
    onnxruntime = prev.onnxruntime.override {
      onnxruntime = pkgs.onnxruntime.override { cudaSupport = false; };
    };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    tables = prev.tables.overridePythonAttrs { doCheck = false; };
    tensorflow-datasets =
      if gpuSupport
      then
        # https://github.com/NixOS/nixpkgs/pull/419210
        prev.tensorflow-datasets.overridePythonAttrs
          (previousAttrs: {
            build-system = [ final.setuptools ];
            dependencies = previousAttrs.dependencies or [ ] ++ [
              final.pyarrow
            ];
            doCheck = false;
          })
      else prev.tensorflow-datasets;
    # use torch-bin to avoid expensive build of magma etc. on cuda
    # and torch-no-triton to avoid recompiling when triton changes
    torch =
      if gpuSupport
      then final.torch-bin
      else prev.torch.override { tritonSupport = false; };
    torch-bin =
      if gpuSupport
      # default triton is triton-bin, causing a conflict
      then prev.torch-bin.override { inherit (final) triton; }
      else prev.torch-bin;
    torchvision =
      if gpuSupport
      then final.torchvision-bin
      else prev.torchvision;
    # TODO: gpuSupport for triton-cpu
    triton' = final.callPackage ./triton { };
    triton =
      let
        triton'' = final.triton'.override {
          llvm = (pkgs.triton-llvm.override {
            llvmProjectsToBuild = [ "mlir" "llvm" "lld" ];
          }).overrideAttrs (previousAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "llvm";
              repo = "llvm-project";
              rev = "a66376b0dc3b2ea8a84fda26faca287980986f78";
              hash = "sha256-7xUPozRerxt38UeJxA8kYYxOQ4+WzDREndD2+K0BYkU=";
            };
            patches = [
              # https://github.com/NixOS/nixpkgs/pull/392651
              (pkgs.fetchpatch2 {
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
        };
      in
      if gpuSupport then triton''
      else final.triton-cpu;
    triton-cpu = final.callPackage ./triton-cpu { triton = final.triton'; };
    wandb = prev.wandb.overridePythonAttrs (previousAttrs: {
      # https://github.com/NixOS/nixpkgs/pull/389616
      dependencies = previousAttrs.dependencies or [ ] ++ [ final.pydantic ];
      # not actually changing any dependencies, only in tests
      doCheck = false;
    });
  });
}
