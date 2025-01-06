{ lib
, config
, fetchFromGitHub
, buildPythonPackage
, triton
, torch
, pytestCheckHook
, cudaSupport ? config.cudaSupport
}:

buildPythonPackage {
  pname = "kernels";
  version = "0-unstable-2024-11-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "triton-lang";
    repo = "kernels";
    rev = "eeeebdd8be7d13629de22d600621e6234057eed3";
    hash = "sha256-6ERjYxRI1XO2LLAaUQxJqrQPFYKvA8gLU0kVmYndGDU=";
  };

  patches = [
    ./fix-build.patch
  ];

  dependencies = [
    triton
    torch
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # tests require cuda
  doCheck = cudaSupport;

  pythonImportsCheck = [
    "kernels"
  ];

  meta = with lib; {
    description = "Triton kernels";
    homepage = "https://github.com/triton-lang/kernels";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
