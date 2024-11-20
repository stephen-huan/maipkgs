{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, numpy
, requests
, pytest
}:

buildPythonPackage {
  pname = "mugrade";
  version = "1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dlsyscourse";
    repo = "mugrade";
    rev = "656cdc2b7ad5a37e7a5347a7b0405df0acd72380";
    hash = "sha256-POD2YQAwqSM3NkkSDTHjOnIjAktGf0TrxFEuM20bz6E=";
  };

  patches = [
    ./argparse.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pytest
    requests
  ];

  pythonImportsCheck = [
    "mugrade"
  ];

  meta = with lib; {
    description = "Interface library for minimalist autograding site";
    homepage = "https://github.com/dlsyscourse/mugrade";
    maintainers = with maintainers; [ stephen-huan ];
  };
}
