{ pkgs }:

let
  inherit (pkgs.config) cudaSupport rocmSupport;
  gpuSupport = cudaSupport || rocmSupport;
in
pkgs.lib.fix (self: {
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hdf5_1_10 = pkgs.callPackage ./hdf5_1_10 { };
  hlibpro = pkgs.callPackage ./hlibpro { inherit (self) hdf5_1_10; };
  sleef = pkgs.callPackage ./sleef { inherit (self) tlfloat; };
  tlfloat = pkgs.callPackage ./tlfloat { };
  leanPackages = pkgs.leanPackages.overrideScope (final: prev: {
    con-leche = final.callPackage ./con-leche { };
    lean4export = final.callPackage ./lean4export { };
    lean4lean = final.callPackage ./lean4lean { leanPackages = final; };
  });
  python3Packages = pkgs.python314Packages.overrideScope (final: prev: {
    dppy = final.callPackage ./dppy { };
    einops = prev.einops.overridePythonAttrs { doCheck = !gpuSupport; };
    etils = (prev.etils.override {
      tensorflow = pkgs.emptyDirectory;
    }).overridePythonAttrs {
      doCheck = false;
    };
    flax = (prev.flax.override {
      inherit (final) treescope;
    }).overridePythonAttrs {
      doCheck = false;
    };
    gpjax = final.callPackage ./gpjax { };
    jax-triton = final.callPackage ./jax-triton { };
    k-means-constrained = final.callPackage ./k-means-constrained { };
    lineax = prev.lineax.overridePythonAttrs { doCheck = !gpuSupport; };
    meshpy = final.callPackage ./meshpy { };
    mugrade = final.callPackage ./mugrade { };
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    orbax-checkpoint = prev.orbax-checkpoint.overridePythonAttrs {
      doCheck = !gpuSupport;
    };
    osqp = prev.osqp.overridePythonAttrs { doCheck = !gpuSupport; };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    # https://github.com/NixOS/nixpkgs/pull/592921
    pot = final.callPackage ./pot { };
    pymetis = final.callPackage ./pymetis { inherit (final) meshpy; };
    sphinx-immaterial = final.callPackage ./sphinx-immaterial { };
    tensorflow-datasets = (prev.tensorflow-datasets.override {
      inherit (final) etils;
    }).overridePythonAttrs {
      doCheck = false;
    };
    treescope = prev.treescope.overridePythonAttrs { doCheck = !gpuSupport; };
    xarray = prev.xarray.overridePythonAttrs {
      doCheck = false;
    };
  });
  rustPackages = pkgs.rustPackages.overrideScope (final: prev: {
    con-ron = final.callPackage ./con-ron { };
    nanoda = final.callPackage ./nanoda { };
  });
})
