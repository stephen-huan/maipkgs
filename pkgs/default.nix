{ pkgs }:

let
  inherit (pkgs.config) cudaSupport rocmSupport;
  gpuSupport = cudaSupport || rocmSupport;
in
{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { };
  python3Packages = pkgs.python3Packages.overrideScope (final: prev: {
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
    # long build, only in tests
    onnxruntime = prev.onnxruntime.override {
      onnxruntime = pkgs.onnxruntime.override { cudaSupport = false; };
    };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    # use torch-bin to avoid expensive build of magma etc. on cuda
    # and torch-no-triton to avoid recompiling when triton changes
    torch =
      if gpuSupport
      # default triton is triton-bin, causing a conflict
      then final.torch-bin.override { inherit (final) triton; }
      else prev.torch.override { tritonSupport = false; };
    # TODO: gpuSupport for triton-cpu
    triton = if gpuSupport then prev.triton else final.triton-cpu;
    triton-cpu = final.callPackage ./triton-cpu { inherit (prev) triton; };
    wandb = prev.wandb.overridePythonAttrs (previousAttrs: {
      # https://github.com/NixOS/nixpkgs/pull/389616
      dependencies = previousAttrs.dependencies or [ ] ++ [ final.pydantic ];
      # not actually changing any dependencies, only in tests
      doCheck = false;
    });
  });
}
