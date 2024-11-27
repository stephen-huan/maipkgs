{ pkgs }:

{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  python3Packages = pkgs.python311Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax { };
    mktestdocs = final.callPackage ./mktestdocs { };
    mugrade = final.callPackage ./mugrade { };
    pbbfmm3d = final.callPackage ./pbbfmm3d { };
  });
}
