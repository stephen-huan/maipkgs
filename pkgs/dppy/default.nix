{ lib
, fetchPypi
, buildPythonPackage
, fetchpatch2
, setuptools
, numpy
, scipy
, matplotlib
, cvxopt
, networkx
, pytestCheckHook
, zonotopeSupport ? false
, treesSupport ? false
}:

buildPythonPackage rec {
  pname = "dppy";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    pname = "dppy";
    inherit version;
    hash = "sha256-z9OBspxTXmLfs0djalTLCl4Y+1yk9V4gbcnFsU47qYA=";
  };

  patches = [
    (fetchpatch2 {
      name = "fix-tests.patch";
      url = "https://github.com/guilgautier/DPPy/pull/79.patch";
      hash = "sha256-fhG6yCy9wOKp17Z/3xd3xsqhkH9asbSUuZnKosjSa2E=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
  ]
  ++ lib.optional zonotopeSupport cvxopt
  ++ lib.optional treesSupport networkx;

  nativeCheckInputs = [
    pytestCheckHook
    cvxopt
    networkx
  ];

  pythonImportsCheck = [
    "dppy"
  ];

  disabledTests = [
    # tries to open windows
    "test_plot"
  ];

  meta = with lib; {
    description = "Python toolbox for sampling Determinantal Point Processes";
    homepage = "https://dppy.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
