{ lib
, fetchFromGitHub
, buildPythonPackage
, fetchpatch2
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
  version = "0.9.4";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${version}";
    sha256 = "sha256-X2pFFaN+QuNMcKNm1fpdN8YA+Fnj9P+bU5RWeldZOy4=";
  };

  pythonRelaxDeps = [
    "jax"
    "jaxlib"
    "cola-ml"
    "jaxopt"
    "flax"
    "numpy"
  ];

  patches = [
    (fetchpatch2 {
      name = "jaxtyping-flax.patch";
      url = "https://github.com/JaxGaussianProcesses/GPJax/pull/498.patch";
      hash = "sha256-ZXeJEIb/MbV3AIqAjIy1WiPlfFmBHQCw1T0r4lWRa7c=";
    })
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

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
