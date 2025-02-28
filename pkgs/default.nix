{ pkgs }:

let
  inherit (pkgs.config) cudaSupport;
in
{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { };
  python3Packages = pkgs.python3Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax { };
    # has a tendancy to oom, even with a small number of cores
    jax =
      if cudaSupport
      then prev.jax.overridePythonAttrs { doCheck = false; }
      else prev.jax;
    jax-triton = final.callPackage ./jax-triton { };
    # not actually changing any dependencies, only in tests
    keras = prev.keras.overridePythonAttrs { doCheck = false; };
    kernels = final.callPackage ./kernels { };
    mugrade = final.callPackage ./mugrade { };
    # long build, only in tests
    onnxruntime = prev.onnxruntime.override {
      onnxruntime = pkgs.onnxruntime.override { cudaSupport = false; };
    };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    # use torch-bin to avoid expensive build of magma etc. on cuda
    # and torch-no-triton to avoid recompiling when triton changes
    torch =
      if cudaSupport
      # default triton is triton-bin, causing a conflict
      then final.torch-bin.override { inherit (final) triton; }
      else prev.torch.override { tritonSupport = false; };
    # TODO: cudaSupport for triton-cpu
    triton = if cudaSupport then prev.triton else final.triton-cpu;
    triton-cpu = final.callPackage ./triton-cpu { inherit (prev) triton; };
  });
}
