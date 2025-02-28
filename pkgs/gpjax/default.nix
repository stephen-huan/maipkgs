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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace \
        'jax<0.4.28' \
        'jax>=0.4.28' \
      --replace \
        'jaxlib<0.4.28' \
        'jaxlib>=0.4.28' \
      --replace \
        'tensorflow-probability>=0.24.0' \
        'tensorflow-probability>=0.21.0' \
      --replace \
        'cola-ml==0.0.5' \
        'cola-ml>=0.0.5' \
      --replace \
        'jaxopt==0.8.2' \
        'jaxopt>=0.8.2' \
      --replace \
        'numpy<2.0.0' \
        'numpy>=2.0.0' \
  '';

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
