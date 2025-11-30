{ lib
, fetchFromGitHub
, buildNpmPackage
, nodejs
, buildPythonPackage
, setuptools
, setuptools_scm
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
  version = "0.13.8";
  pyproject = true;

  # no source distributions on PyPi
  src = fetchFromGitHub {
    owner = "jbms";
    repo = "sphinx-immaterial";
    tag = "v${version}";
    hash = "sha256-g7j+r3cdlY/rtKVWQMkZMKiTdY/0aetlKqbNGViXeUE=";
  };

  npmDeps = buildNpmPackage {
    inherit pname version src;

    npmDepsHash = "sha256-3+XXPUhCKAKBDHVMwruyNlFqVlBVjSLYCWXHqWdo3UM=";

    makeCacheWritable = true;

    installPhase = ''
      mkdir -p $out
      cp -r node_modules -t $out
    '';
  };

  preBuild = ''
    cp -r ${npmDeps}/node_modules -T node_modules
    chmod +w -R node_modules
  '';

  build-system = [
    setuptools
    setuptools_scm
    nodejs
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
