{ lib
, fetchFromGitHub
, buildPythonPackage
, fetchpatch2
, hatchling
, jax
, optax
, numpyro
, jaxtyping
, tqdm
, beartype
, cola-ml
, flax
, numpy
, pytestCheckHook
, pytest-xdist
, mktestdocs
, networkx
}:

buildPythonPackage rec {
  pname = "gpjax";
  version = "0.11.1";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${version}";
    sha256 = "sha256-4gFaWTF3fU9g4KCQQDlOd50WaH3REQ3oie20Qu8laVQ=";
  };

  patches = [
    (fetchpatch2 {
      name = "jax-deprecations.patch";
      url = "https://github.com/JaxGaussianProcesses/GPJax/pull/521.patch";
      hash = "sha256-KRA6KrHAKwNgJ+K+no4t2V6K1CAJq3KANGfgSy1nCyg=";
    })
  ];

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
    cola-ml
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
