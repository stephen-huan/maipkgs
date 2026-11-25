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

buildPythonPackage (finalAttrs: {
  pname = "jax-triton";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jax_triton";
    inherit (finalAttrs) version;
    hash = "sha256-hbjXsWm9W3lOFau2D3v0dkyiip7QzwDecX/Zpg+k8/k=";
  };

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
})
