{ lib
, fetchFromGitHub
, fetchpatch2
, buildPythonPackage
, setuptools
, setuptools-scm
, scipy
, tqdm
, cola-plum-dispatch
, optree
, pytreeclass
, beartype
, typing-extensions
, pytest
, pytestCheckHook
, jax
, jaxlib
, torch
}:

buildPythonPackage {
  pname = "cola-ml";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wilson-labs";
    repo = "cola";
    rev = "9562ae1ff850ae99c96d5da441a5850184c66a1e";
    hash = "sha256-swFJxCT0DkZpQnsSJXkmWZ4yEDh9k5MjA8xk5WxnCPU=";
  };

  patches = [
    (fetchpatch2 {
      name = "array-device.patch";
      url = "https://github.com/wilson-labs/cola/pull/93.diff";
      hash = "sha256-roo6lGrMTOtPGHRvK+fv4uVDmWpmNllIqtoIOn/JVSw=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    scipy
    tqdm
    cola-plum-dispatch
    optree
    pytreeclass
    beartype
    typing-extensions
    pytest
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jax
    jaxlib
    torch
  ];

  disabledTests = [
    "test_get_lu_from_tridiagonal"
    "test_vmappable_constructor"
    "test_arnoldi_vjp"
    "test_lanczos_vjp"
    "test_unary"
    "test_arnoldi_matrix_market"
    "test_lanczos_matrix_market"
  ];

  disabledTestPaths = [
    # tests that take a long time
    "tests/linalg/test_inverse.py"
    "tests/linalg/test_logdet.py"
  ];

  pythonImportsCheck = [
    "cola"
  ];

  meta = with lib; {
    description = "Compositional Linear Algebra";
    homepage = "https://cola.readthedocs.io/en/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
