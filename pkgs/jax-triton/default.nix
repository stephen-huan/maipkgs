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
  version = "0.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jax_triton";
    inherit version;
    hash = "sha256-7VZKX/ueQEVX3I0pbn6zDlAdpaTXsDQIrNCDfBxhjCE=";
  };

  patches = [
    (fetchpatch2 {
      name = "extend-deprecated.patch";
      url = "https://github.com/jax-ml/jax-triton/pull/317.patch";
      hash = "sha256-syVOSun1y/LPMpgBJyLYhvLyY4IYKDcUGFYW0iZc3Oc=";
    })
    (fetchpatch2 {
      name = "triton_call-annotation.patch";
      url = "https://github.com/jax-ml/jax-triton/pull/323.patch";
      hash = "sha256-sWAIYLVD2Lpatnpxp07Dwn7Pm3vIq0+BcqyoT0ha9Fw=";
    })
    (fetchpatch2 {
      name = "cpu-backend.patch";
      url = "https://github.com/jax-ml/jax-triton/pull/322.patch";
      hash = "sha256-OxEdXxe45KSuqTvIfVcV2+OBAYMY0cbCVc48GueDR5U=";
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
