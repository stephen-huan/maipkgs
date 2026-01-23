{ lib
, config
, fetchFromGitHub
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

buildPythonPackage {
  pname = "jax-triton";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "jax-triton";
    rev = "a298a7884054d3fc4bf94e1cb3d2a3baa907ea6b";
    hash = "sha256-z853dxGWg3vLklYqSvapRLnhwwkPBRqtSAzGmE9rLns=";
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
