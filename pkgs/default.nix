{ pkgs }:

{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { };
  python3Packages = pkgs.python3Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax { };
    jax-triton = final.callPackage ./jax-triton { };
    kernels = final.callPackage ./kernels { };
    mugrade = final.callPackage ./mugrade { };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    triton-cpu = final.callPackage ./triton-cpu { };
  });
}
