{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mktestdocs";
  version = "0.2.1";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "koaning";
    repo = "mktestdocs";
    rev = version;
    sha256 = "sha256-snlt6SDiDYr04b2b2NgBC/1IBffpei034vFx3fnYUOc=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mktestdocs"
  ];

  meta = with lib; {
    description = "Run pytest against markdown files/docstrings";
    homepage = "https://github.com/koaning/mktestdocs";
    license = licenses.asl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
