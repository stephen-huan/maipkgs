{ lib
, stdenv
, fetchFromGitHub
, gnumake
, fftw
, blas
, lapack
}:

stdenv.mkDerivation {
  pname = "bbfmm3d";
  version = "0-unstable-2018-09-13";

  src = fetchFromGitHub {
    owner = "ruoxi-wang";
    repo = "BBFMM3D";
    rev = "0b7a2410e1d1ce6f9fd3456f70f4f990f83cf6e0";
    hash = "sha256-tIQ6wQvVoXkSL/OFgP4DGZPqFSBVcZ6wo/ErUFOJ+Z4=";
  };

  patches = [
    ./fftw3.patch
    ./Makefile.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    gnumake
  ];

  buildInputs = [
    fftw
    blas
    lapack
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $dev/include
    cp -r include -T $dev/include
    mkdir -p $out/src
    cp -r src -T $out/src

    runHook postInstall
  '';

  meta = with lib; {
    description = "Black-box Fast Multipole Method in 3 dimensions";
    homepage = "https://github.com/ruoxi-wang/BBFMM3D";
    license = licenses.mpl20;
    maintainers = with maintainers; [ stephen-huan ];
  };
}
