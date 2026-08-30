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
  python3Packages = pkgs.python313Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    dppy = final.callPackage ./dppy { };
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
    mugrade = final.callPackage ./mugrade { };
    numpyro = prev.numpyro.overridePythonAttrs { doCheck = false; };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    sphinx-immaterial = final.callPackage ./sphinx-immaterial { };
    # https://github.com/NixOS/nixpkgs/pull/502523
    tensorflow-datasets = prev.tensorflow-datasets.overridePythonAttrs {
      doCheck = false;
    };
  });
  rustPackages = pkgs.rustPackages.overrideScope (final: prev: {
    nanoda = final.callPackage ./nanoda { };
  });
}
