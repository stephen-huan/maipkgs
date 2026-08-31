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
  version = "0.9.1";
  pyproject = true;
  __structuredAttrs = true;

  # PyPi source doesn't contain tests
  src = fetchFromGitHub {
    owner = "joshlk";
    repo = "k-means-constrained";
    # tags out of date
    rev = "d662945da2262549b48c6e844b45362a7b5fd982";
    hash = "sha256-KLyPW7wIwcXSmXq32SH5zhTy2tykUqScXlJRwRR6rZg=";
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
