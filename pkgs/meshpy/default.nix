{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch2
, meson-python
, numpy
, pybind11
, pytestCheckHook
, matplotlib
}:

buildPythonPackage (finalAttrs: {
  pname = "meshpy";
  version = "2026.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ITdrM5qdnAF8m7HpEm9llbNEyMd5DgDObUbpKe3Z0v8=";
  };

  patches = [
    # https://github.com/inducer/meshpy/pull/170
    (fetchpatch2 {
      name = "fix-test.patch";
      url = "https://github.com/inducer/meshpy/commit/aacd52715e6a828c50739e8140889f8e34940b3e.patch?full_index=1";
      hash = "sha256-9U+jUSGxe3Hp3Ior9ovas8K+NiCpZQ9w8+yut+w+NxY=";
    })
  ];

  build-system = [
    meson-python
    numpy
    pybind11
  ];

  dependencies = [
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
  ];

  pythonImportsCheck = [
    "meshpy"
  ];

  # compiled extension modules
  preCheck = ''
    rm -r meshpy
  '';

  meta = {
    description = "2D/3D simplicial mesh generator interface for Python";
    homepage = "http://mathema.tician.de/software/meshpy";
    license = with lib.licenses; [
      # Triangle
      (lib.licenses.mkLicense {
        shortName = "triangle";
        fullName = "Triangle License";
        free = false;
        redistributable = true;
      })
      # TetGen
      agpl3Plus
      # wrapper
      mit
    ];
    maintainers = with lib.maintainers; [ stephen-huan ];
  };
})
