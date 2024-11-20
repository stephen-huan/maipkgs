{ pkgs }:

{
  bbfmm3d = pkgs.callPackage ./bbfmm3d { };
  python3Packages = pkgs.python311Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax { };
    mktestdocs = final.callPackage ./mktestdocs { };
    mugrade = final.callPackage ./mugrade { };
    # see tensorflow-build in pkgs/top-level/python-packages.nix
    orbax-checkpoint = prev.orbax-checkpoint.override {
      protobuf = final.protobuf4.override {
        protobuf = pkgs.protobuf_21.override {
          abseil-cpp = pkgs.abseil-cpp_202301;
        };
      };
    };
    tensorflow-probability = prev.tensorflow-probability.overridePythonAttrs
      (previousAttrs: {
        src = previousAttrs.src.overrideAttrs {
          patches = [
            (pkgs.fetchpatch2 {
              name = "sort-kind.patch";
              url = "https://github.com/tensorflow/probability/commit/3e652805bc2b57189c18df0228e3749f528fe21a.diff";
              hash = "sha256-J6SjylsSSG+zazTTQAevyS/UXSYhSrkk3KPCjNEXNMQ=";
            })
          ];
        };
      });
  });
}
