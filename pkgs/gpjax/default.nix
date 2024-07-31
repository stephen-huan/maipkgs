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
  version = "0.8.2";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    rev = "v${version}";
    sha256 = "sha256-2mjmKyPEplO5OAH8Ea7UYKxSSmb1Osk/d6RUR/9JkU8=";
  };

  patches = [
    ./dict.patch
    ./posterior.patch
  ];

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

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
