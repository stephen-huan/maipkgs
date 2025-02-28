{ pkgs }:

let
  inherit (pkgs.config) cudaSupport;
  cudaLibPath = pkgs.lib.makeLibraryPath (
    with pkgs.cudaPackages; [
      (lib.getLib libcublas) # libcublas.so
      (lib.getLib cuda_cupti) # libcupti.so
      (lib.getLib cuda_cudart) # libcudart.so
      (lib.getLib cudnn) # libcudnn.so
      (lib.getLib libcufft) # libcufft.so
      (lib.getLib libcusolver) # libcusolver.so
      (lib.getLib libcusparse) # libcusparse.so
      (lib.getLib nccl) # libnccl.so
      (lib.getLib libnvjitlink) # libnvJitLink.so
      (lib.getLib pkgs.addDriverRunpath.driverLink) # libcuda.so
    ]
  );
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
    # https://github.com/NixOS/nixpkgs/pull/375186
    jax-cuda12-pjrt = prev.jax-cuda12-pjrt.overridePythonAttrs {
      preInstallCheck = ''
        patchelf --add-rpath "${cudaLibPath}" $out/${final.python.sitePackages}/jax_plugins/xla_cuda12/xla_cuda_plugin.so
      '';
    };
    jax-cuda12-plugin = prev.jax-cuda12-plugin.overridePythonAttrs {
      postInstall = ''
        mkdir -p $out/${final.python.sitePackages}/jax_cuda12_plugin/cuda/bin
        ln -s ${pkgs.lib.getExe' pkgs.cudaPackages.cuda_nvcc "ptxas"} $out/${final.python.sitePackages}/jax_cuda12_plugin/cuda/bin
        ln -s ${pkgs.lib.getExe' pkgs.cudaPackages.cuda_nvcc "nvlink"} $out/${final.python.sitePackages}/jax_cuda12_plugin/cuda/bin
      '';
      preInstallCheck = ''
        patchelf --add-rpath "${cudaLibPath}" $out/${final.python.sitePackages}/jax_cuda12_plugin/*.so
      '';
      doCheck = true;
    };
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
