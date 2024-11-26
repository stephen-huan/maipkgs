{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, gnumake
, boost
, fftw
, blas
, lapack
, mkl
, numpy
, withMkl ? false
}:

let
  python = boost.pythonModule;
  pythonVersion = lib.versions.majorMinor python.version;
in
buildPythonPackage {
  pname = "pbbfmm3d";
  version = "0-unstable-2024-11-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stephen-huan";
    repo = "PBBFMM3D";
    rev = "4a97e47e734a0b04e31efe0f7d24bdb1091a4b41";
    hash = "sha256-9OPf0neQmYh6TlT+tTkiZUakJgxJdn2ZlKvFXBM1EwA=";
  };

  env = {
    BOOST_INC = "${lib.getDev boost}/include";
    BOOST_LIB = "${lib.getLib boost}/lib";
    FFTW_INCLUDE = "${lib.getDev fftw}/include";
    FFTW_LIB = "${lib.getLib fftw}/lib";
    PYTHON_INCLUDE = "${lib.getDev python}/include/python${pythonVersion}";
    PYTHON_LIB = "${lib.getLib python}/lib";
    PYTHON_VERSION = pythonVersion;
  } // lib.optionalAttrs withMkl { MKLROOT = "${mkl}"; };

  build-system = [
    setuptools
    gnumake
  ];

  buildInputs = [
    boost
    fftw
  ] ++ lib.optional withMkl mkl
  ++ lib.optional (!withMkl) blas
  ++ lib.optional (!withMkl) lapack;

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "pbbfmm3d"
  ];

  meta = with lib; {
    description = "Parallel Black-box Fast Multipole Method in 3 dimensions";
    homepage = "https://github.com/ruoxi-wang/PBBFMM3D";
    license = licenses.mpl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
