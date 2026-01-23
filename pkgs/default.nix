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
    blosc2 = prev.blosc2.overridePythonAttrs { doCheck = !gpuSupport; };
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    dppy = final.callPackage ./dppy { };
    gpjax = final.callPackage ./gpjax { };
    jax-triton = final.callPackage ./jax-triton { };
    mugrade = final.callPackage ./mugrade { };
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    sphinx-immaterial = final.callPackage ./sphinx-immaterial { };
    tables = prev.tables.overridePythonAttrs { doCheck = !gpuSupport; };
  });
}
