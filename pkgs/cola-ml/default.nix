{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, setuptools-scm
, scipy
, tqdm
, cola-plum-dispatch
, optree
, pytestCheckHook
, jax
, jaxlib
, torch
}:

buildPythonPackage rec {
  pname = "cola-ml";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wilson-labs";
    repo = "cola";
    tag = "v${version}";
    hash = "sha256-w34M7VXrjJ/8Y45ki62aXwcOsNhiFs65YoIEYTXEhH4=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    scipy
    tqdm
    cola-plum-dispatch
    optree
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jax
    jaxlib
    torch
  ];

  disabledTests = [
    # 'jaxlib.xla_extension.ArrayImpl' object has no attribute 'device'
    "test_sparse"
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
