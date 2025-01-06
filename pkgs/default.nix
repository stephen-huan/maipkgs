{ pkgs }:

{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  hlibpro = pkgs.callPackage ./hlibpro { };
  sleef = pkgs.callPackage ./sleef { };
  python3Packages = pkgs.python3Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax { };
    jaxopt = prev.jaxopt.overridePythonAttrs (previousAttrs: {
      patches = previousAttrs.patches or [ ] ++ [
        (pkgs.fetchpatch2 {
          name = "escape-sequences.patch";
          url = "https://patch-diff.githubusercontent.com/raw/google/jaxopt/pull/591.diff";
          hash = "sha256-u9a6H72lfsTR9lCjcocsEjPnv9UUbASNmRquL7EJeLA=";
        })
      ];
    });
    jax-triton = final.callPackage ./jax-triton { };
    kernels = final.callPackage ./kernels { };
    mugrade = final.callPackage ./mugrade { };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
    triton-cpu = final.callPackage ./triton-cpu { };
  });
}
