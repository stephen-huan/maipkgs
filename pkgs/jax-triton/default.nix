{ lib
, config
, fetchPypi
, buildPythonPackage
, fetchpatch2
, setuptools
, setuptools-scm
, absl-py
, jax
, jaxlib
, triton
, pytestCheckHook
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
      name = "cpu-backend.patch";
      url = "https://github.com/jax-ml/jax-triton/pull/322.diff";
      hash = "sha256-Cv5blgoB0zzEeQ8glPTibkOHh2HR3fO02Ci9Na/6fKA=";
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace \
        'jax>=0.4.34' \
        'jax>=0.4.28' \
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    absl-py
    jax
    jaxlib
    triton
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests require cuda
  doCheck = cudaSupport;

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
