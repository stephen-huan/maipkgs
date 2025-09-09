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
        prev.tensorflow-datasets.overridePythonAttrs
          (previousAttrs: {
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
    triton = if gpuSupport then prev.triton else final.triton-cpu;
    triton-cpu = final.callPackage ./triton-cpu { triton = final.triton'; };
    wandb = prev.wandb.overridePythonAttrs (previousAttrs: {
      # https://github.com/NixOS/nixpkgs/pull/389616
      dependencies = previousAttrs.dependencies or [ ] ++ [ final.pydantic ];
      # not actually changing any dependencies, only in tests
      doCheck = false;
    });
  });
}
