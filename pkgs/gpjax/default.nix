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
, equinox
, paramax
, lineax
, scipy
, numpy
, rich
, pytestCheckHook
, pytest-xdist
, mktestdocs
, networkx
, hypothesis
}:

buildPythonPackage (finalAttrs: {
  pname = "gpjax";
  version = "0.18.0";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "JaxGaussianProcesses";
    repo = "GPJax";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JaA2ZR6ctUstrGmW1OleeYSTgrJe3KslduJjnrvmjSc=";
  };

  pythonRelaxDeps = [
    "jax"
    "jaxlib"
  ];

  patches = [
    # https://github.com/thomaspinder/GPJax/pull/737
    (fetchpatch2 {
      name = "fix-mark.patch";
      url = "https://github.com/thomaspinder/GPJax/commit/38bbe486eaeff6ca26a6457158a77e7f5b4a1307.patch?full_index=1";
      hash = "sha256-j3lANHTi+R8WgPXl0k4kKX3ptMAHl5JTYKZ1pp924Dc=";
    })
    # https://github.com/thomaspinder/GPJax/pull/777
    (fetchpatch2 {
      name = "fix-regex.patch";
      url = "https://github.com/thomaspinder/GPJax/commit/57bb33f986aa3564462272b0dab1d97e7cabca26.patch?full_index=1";
      hash = "sha256-1IotFRlJp5fs/4E44kXCPetVSL5CbdBU9r3mdj+SG54=";
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
    equinox
    paramax
    lineax
    scipy
    numpy
    rich
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

  pytestFlags = [ "." "-v" "-n auto" ];

  meta = with lib; {
    description = "Gaussian processes in JAX";
    homepage = "https://docs.jaxgaussianprocesses.com";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
})
