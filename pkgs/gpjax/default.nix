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

buildPythonPackage rec {
  pname = "gpjax";
  version = "0.9.0";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    rev = "v${version}";
    sha256 = "sha256-XqU1W0G1EeZ4qveQWNyXXnJa6OTY4oxWhngDJHhhE9A=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace \
        'jax = "<0.4.28"' \
        'jax = ">=0.4.28"' \
      --replace \
        'jaxlib = "<0.4.28"' \
        'jaxlib = ">=0.4.28"' \
      --replace \
        'tensorflow-probability = "^0.24.0"' \
        'tensorflow-probability = ">=0.21.0"' \
      --replace \
        'beartype = "^0.16.1"' \
        'beartype = ">=0.16.1"'
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
    flax
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jaxlib
    networkx
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
