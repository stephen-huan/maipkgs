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
, equinox
, paramax
, lineax
, scipy
, numpy
, rich
, xarray
, pytestCheckHook
, pytest-xdist
, mktestdocs
, networkx
, hypothesis
}:

buildPythonPackage (finalAttrs: {
  pname = "gpjax";
  version = "1.1.0";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "QuantClimate";
    repo = "GPJax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K1EH7Lz1dabeVB0KIM6DWMj2z2kxoZhUFSAkcswyun4=";
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
    equinox
    paramax
    lineax
    scipy
    numpy
    rich
    xarray
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    mktestdocs
    networkx
    hypothesis
  ];

  pythonImportsCheck = [
    "gpjax"
  ];

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
})
