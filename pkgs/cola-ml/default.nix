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

  patches = [
    # https://github.com/wilson-labs/cola/pull/113
    ./jax-deprecations.patch
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jax
    torch
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
