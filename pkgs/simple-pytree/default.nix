{ lib
, fetchFromGitHub
, buildPythonPackage
, poetry-core
, jax
, jaxlib
, typing-extensions
, pytestCheckHook
, flax
}:

buildPythonPackage rec {
  pname = "simple_pytree";
  version = "0.2.2";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = "simple-pytree";
    rev = version;
    sha256 = "sha256-iB0DOLraRXMhLAqcV7KxziCtvuRICL1OYvLbI34KdLQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    jax
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jaxlib
    flax
  ];

  pythonImportsCheck = [
    "simple_pytree"
  ];

  meta = with lib; {
    description = "Simple package for creating custom JAX pytree objects";
    homepage = "https://github.com/cgarciae/simple-pytree";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
