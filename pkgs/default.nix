{ pkgs }:

let
  inherit (pkgs.config) cudaSupport rocmSupport;
  gpuSupport = cudaSupport || rocmSupport;
in
rec {
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  # https://github.com/NixOS/nixpkgs/pull/558183
  or-tools' = pkgs.callPackage ./or-tools/package.nix { };
  sleef = pkgs.callPackage ./sleef { inherit tlfloat; };
  tlfloat = pkgs.callPackage ./tlfloat { };
  leanPackages = pkgs.leanPackages.overrideScope (final: prev: {
    comparator = final.callPackage ./comparator { leanPackages = final; };
    lean4export = final.callPackage ./lean4export { };
    # https://github.com/leanprover/comparator/pull/49
    lean4checker = final.callPackage ./lean4checker { };
  });
  python3Packages = pkgs.python314Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    dppy = final.callPackage ./dppy { };
    einops = prev.einops.overridePythonAttrs { doCheck = !gpuSupport; };
    etils = (prev.etils.override {
      tensorflow = pkgs.emptyDirectory;
    }).overridePythonAttrs
      { doCheck = false; };
    flax = (prev.flax.override {
      inherit (final) treescope;
    }).overridePythonAttrs {
      doCheck = false;
    };
    gpjax = final.callPackage ./gpjax { };
    jax-triton = final.callPackage ./jax-triton { };
    k-means-constrained = (
      final.callPackage ./k-means-constrained { }
    ).override {
      ortools = (final.toPythonModule (or-tools'.override {
        python3 = final.python;
        # https://github.com/NixOS/nixpkgs/pull/557250
        gtest = pkgs.gtest.overrideAttrs { strictDeps = false; };
      })).python;
    };
    lineax = prev.lineax.overridePythonAttrs { doCheck = !gpuSupport; };
    mugrade = final.callPackage ./mugrade { };
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    orbax-checkpoint = prev.orbax-checkpoint.overridePythonAttrs {
      doCheck = !gpuSupport;
    };
    osqp = prev.osqp.overridePythonAttrs { doCheck = !gpuSupport; };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    sphinx-immaterial = final.callPackage ./sphinx-immaterial { };
    tensorflow-datasets = (prev.tensorflow-datasets.override {
      inherit (final) etils;
    }).overridePythonAttrs {
      doCheck = false;
    };
    treescope = prev.treescope.overridePythonAttrs { doCheck = !gpuSupport; };
  });
  rustPackages = pkgs.rustPackages.overrideScope (final: prev: {
    nanoda = final.callPackage ./nanoda { };
  });
}
