{ lib
, config
, fetchPypi
, buildPythonPackage
, fetchpatch2
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
  version = "0.3.0-unstable-2025-09-03";
  pyproject = true;

  src = fetchPypi {
    pname = "jax_triton";
    inherit version;
    hash = "sha256-2nuc2PeE3lCybRBKP0xBfAr83YlPmEQryBWoIpAAM+Y=";
  };

  patches = [
    (fetchpatch2 {
      name = "triton-integration.patch";
      url = "https://github.com/jax-ml/jax-triton/compare/v0.3.0...3f0ac49e9500af39fc08dd97133f4eda16df51d2.patch";
      hash = "sha256-+4waBcKR5QG0c8pvLrNhoq9zWVVwjifKl0/VfrtP8yo=";
    })
    (fetchpatch2 {
      name = "cpu-backend.patch";
      url = "https://github.com/jax-ml/jax-triton/pull/322.patch";
      hash = "sha256-T8cr3PhrBIU4NxIINTqiHbklOZQIbfIVmh6VyzUPgJk=";
    })
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
    "jax_triton"
  ];

  meta = with lib; {
    description = "Integrations between JAX and Triton";
    homepage = "https://jax-ml.github.io/jax-triton/";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
