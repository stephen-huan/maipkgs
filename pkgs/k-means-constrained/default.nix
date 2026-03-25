{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, cython
, ortools
, scipy
, numpy
, six
, joblib
, pytestCheckHook
, pandas
, scikit-learn
}:

buildPythonPackage {
  pname = "k-means-constrained";
  version = "0.9.0";
  pyproject = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "joshlk";
    repo = "k-means-constrained";
    # tags out of date
    rev = "5465da91605b074dbae26635bda971eb7c85db49";
    hash = "sha256-yk1XtBJBctJv9jTCvBqDOWH0cTXWD9r132CEeM9JwBo=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [
    ortools
    scipy
    numpy
    six
    joblib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
    scikit-learn
  ];

  pythonImportsCheck = [
    "k_means_constrained"
  ];

  # compiled extension modules
  preCheck = ''
    rm -r k_means_constrained
  '';

  meta = with lib; {
    description = "k-means clustering with constrained cluster size";
    homepage = "https://joshlk.github.io/k-means-constrained/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
