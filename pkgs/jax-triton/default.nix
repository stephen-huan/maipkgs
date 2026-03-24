{ lib
, config
, fetchPypi
, buildPythonPackage
, setuptools
, setuptools-scm
, absl-py
, jax
, triton
, pytestCheckHook
, torch
, cudaSupport ? config.cudaSupport
}:

buildPythonPackage rec {
  pname = "jax-triton";
  version = "0.3.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jax_triton";
    inherit version;
    hash = "sha256-juHlPfsZn1vr7b50OFTzUfww2THu3oK5U8G765wi5ZA=";
  };

  patches = [
    ./fix-cache-dir.patch
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    absl-py
    jax
    triton
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  # TODO: test with cuda
  # https://github.com/NixOS/nixpkgs/pull/256230
  doCheck = cudaSupport && false;

  pythonImportsCheck = [
    # ImportError: jax-triton requires JAX to be installed with GPU support.
    # "jax_triton"
  ];

  meta = with lib; {
    description = "Integrations between JAX and Triton";
    homepage = "https://jax-ml.github.io/jax-triton/";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
