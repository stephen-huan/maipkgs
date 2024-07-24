{ pkgs }:

{
  python3Packages = pkgs.python311Packages.overrideScope (final: prev: {
    cola-ml = final.callPackage ./cola-ml { };
    cola-plum-dispatch = final.callPackage ./cola-plum-dispatch { };
    gpjax = final.callPackage ./gpjax {
      simple-pytree = final.simple-pytree.overridePythonAttrs rec {
        version = "0.1.7";
        src = pkgs.fetchFromGitHub {
          owner = "cgarciae";
          repo = "simple-pytree";
          rev = version;
          sha256 = "sha256-Pss7LUnH8u/QQI+amnlKbqyc8tq8XNpcDJ6541pQxUw=";
        };
      };
    };
    mktestdocs = final.callPackage ./mktestdocs { };
    optree = final.callPackage ./optree { };
    # see tensorflow-build in pkgs/top-level/python-packages.nix
    orbax-checkpoint = prev.orbax-checkpoint.override {
      protobuf = final.protobuf.override {
        protobuf = pkgs.protobuf_21.override {
          abseil-cpp = pkgs.abseil-cpp_202301;
        };
      };
    };
    pytreeclass = final.callPackage ./pytreeclass { };
    simple-pytree = final.callPackage ./simple-pytree { };
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
