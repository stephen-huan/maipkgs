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
  version = "0.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wilson-labs";
    repo = "cola";
    tag = "v${version}";
    hash = "sha256-n7iaKycJicnqYXQPUy5pd4mbo13t8+01eITj/mQe+P8=";
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
