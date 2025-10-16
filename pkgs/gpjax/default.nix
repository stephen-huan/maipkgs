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
  version = "0.13.0";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${version}";
    hash = "sha256-Sd+miiPUeNsIH19hnWfeTpN1sQizjWL8F6iccJd8/1c=";
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
