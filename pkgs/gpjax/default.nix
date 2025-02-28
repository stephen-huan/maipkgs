{ lib
, fetchFromGitHub
, buildPythonPackage
, hatchling
, jax
, optax
, jaxtyping
, tqdm
, tensorflow-probability
, beartype
, cola-ml
, jaxopt
, flax
, numpy
, pytestCheckHook
, pytest-xdist
, mktestdocs
, networkx
}:

buildPythonPackage rec {
  pname = "gpjax";
  version = "0.9.3";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${version}";
    sha256 = "sha256-SslNnfKQlyXsWlEcqg20gdBR+J8XytJz4rgW/pVmOlI=";
  };

  pythonRelaxDeps = [
    "jax"
    "jaxlib"
    "cola-ml"
    "jaxopt"
    "numpy"
  ];

  build-system = [
    hatchling
  ];

  dependencies = [
    jax
    optax
    jaxtyping
    tqdm
    tensorflow-probability
    beartype
    cola-ml
    jaxopt
    flax
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    mktestdocs
    networkx
  ];

  pythonImportsCheck = [
    "gpjax"
  ];

  pytestFlagsArray = [ "." "-v" "-n auto" ];

  disabledTests = [
    # assert Array(False, dtype=bool)
    "test_expected_improvement_utility_function_correct_values"
    "test_get_batch"
  ];

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
