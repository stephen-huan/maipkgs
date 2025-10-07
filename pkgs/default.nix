{ pkgs }:

let
  inherit (pkgs.config) cudaSupport rocmSupport;
  gpuSupport = cudaSupport || rocmSupport;
in
rec {
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { inherit tlfloat; };
  tlfloat = pkgs.callPackage ./tlfloat { };
  python3Packages = pkgs.python313Packages.overrideScope (final: prev: {
    blosc2 = prev.blosc2.overridePythonAttrs { doCheck = false; };
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    dppy = final.callPackage ./dppy { };
    gpjax = final.callPackage ./gpjax { };
    jax-triton = final.callPackage ./jax-triton { };
    # not actually changing any dependencies, only in tests
    keras = prev.keras.overridePythonAttrs { doCheck = gpuSupport; };
    kernels = final.callPackage ./kernels { };
    mugrade = final.callPackage ./mugrade { };
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    tables = prev.tables.overridePythonAttrs { doCheck = false; };
    tensorflow-datasets = prev.tensorflow-datasets.overridePythonAttrs {
      doCheck = false;
    };
    # use torch-no-triton to avoid recompiling when triton changes
    torch =
      if gpuSupport
      then prev.torch
      else prev.torch.override { tritonSupport = false; };
    # TODO: gpuSupport for triton-cpu
    triton' = final.callPackage ./triton { };
    triton = if gpuSupport then prev.triton else final.triton-cpu;
    triton-cpu = final.callPackage ./triton-cpu { triton = final.triton'; };
  });
}
