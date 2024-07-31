{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, optax
, jaxopt
, jaxtyping
, tqdm
, simple-pytree
, tensorflow-probability
, beartype
, jax
, jaxlib
, orbax-checkpoint
, cola-ml
, pytestCheckHook
, networkx
, flax
, mktestdocs
}:

buildPythonPackage {
  pname = "gpjax";
  version = "0.8.2-unstable-2024-07-16";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    rev = "b69be96d00ef2225a61dbccdd2288519dbc1f16f";
    sha256 = "sha256-jDAgT/tnq2ULFnGhYQMy9dBPVn5uSYt5Phwzdio0gEs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace \
        'optax = "^0.1.4"' \
        'optax = ">=0.1.4"' \
      --replace \
        'tensorflow-probability = "^0.22.0"' \
        'tensorflow-probability = ">=0.21.0"' \
      --replace \
        'beartype = "^0.16.2"' \
        'beartype = ">=0.16.2"'
  '';

  build-system = [
    poetry-core
  ];

  dependencies = [
    optax
    jaxopt
    jaxtyping
    tqdm
    simple-pytree
    tensorflow-probability
    beartype
    jax
    orbax-checkpoint
    cola-ml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jaxlib
    networkx
    flax
    mktestdocs
  ];

  pythonImportsCheck = [
    "gpjax"
  ];

  disabledTests = [
    "test_expected_improvement_utility_function_correct_values"
    "test_non_conjugate_posterior_raises_error"
  ];

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
