{ lib
, fetchFromGitHub
, fetchNpmDeps
, nodejs
, npmHooks
, buildPythonPackage
, setuptools
, setuptools-scm
, sphinx
, markupsafe
, pydantic
, pydantic-extra-types
, typing-extensions
, appdirs
, requests
, pytestCheckHook
, beautifulsoup4
, inline-snapshot
, libclang
, pyyaml
}:

buildPythonPackage rec {
  pname = "sphinx-immaterial";
  version = "0.13.9";
  pyproject = true;

  # no source distributions on PyPi
  src = fetchFromGitHub {
    owner = "jbms";
    repo = "sphinx-immaterial";
    tag = "v${version}";
    hash = "sha256-y0HUCeDlOsGks/4nVUaQiAXBmjsOQDm5NPeuftkafkk=";
  };

  # https://discourse.nixos.org/t/download-npmdeps-in-buildrustpackage/69550/4
  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-2pP7P7XKm3Rbe62DpEeWvbnb6sNcst/bTe2hssSI7kA=";
  };

  makeCacheWritable = true;

  build-system = [
    setuptools
    setuptools-scm
    nodejs
    npmHooks.npmConfigHook
  ];

  dependencies = [
    sphinx
    markupsafe
    pydantic
    pydantic-extra-types
    typing-extensions
    appdirs
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
    beautifulsoup4
    inline-snapshot
    libclang
    pyyaml
  ];

  # involves separate build
  preCheck = ''
    rm -r tests/issue_134
  '';

  # basically completely broken
  doCheck = false;

  pythonImportsCheck = [
    "sphinx_immaterial"
  ];

  meta = with lib; {
    description = "Adaptation of mkdocs-material theme for the Sphinx documentation system";
    homepage = "https://jbms.github.io/sphinx-immaterial/";
    license = licenses.mit;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
