{ lib
, fetchFromGitHub
, buildPythonPackage
, hatchling
, jax
, optax
, numpyro
, jaxtyping
, tqdm
, beartype
, flax
, numpy
, pytestCheckHook
, pytest-xdist
, mktestdocs
, networkx
}:

buildPythonPackage rec {
  pname = "gpjax";
  version = "0.12.2";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${version}";
    sha256 = "sha256-wObGCHfwW28K/4VEthSwg0b0/xow9c/FOHh2ThdFens=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    jax
    optax
    numpyro
    jaxtyping
    tqdm
    beartype
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

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
