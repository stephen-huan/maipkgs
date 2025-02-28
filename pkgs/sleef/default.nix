{ lib
, stdenv
, fetchFromGitHub
, cmake
, fftw
, mpfr
, openssl
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.8";
  pname = "sleef";

  src = fetchFromGitHub {
    owner = "shibatch";
    repo = "sleef";
    tag = finalAttrs.version;
    hash = "sha256-bjT+F7/nyiB4f0T06/flbpIWFZbUxjf1TjWMe3112Ig=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DSLEEF_BUILD_INLINE_HEADERS=TRUE"
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
  ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    fftw
    mpfr
    openssl
  ];

  meta = with lib; {
    description = "SIMD library for evaluating elementary functions";
    homepage = "https://sleef.org/";
    license = licenses.boost;
    maintainers = with maintainers; [ stephen-huan ];
  };
})
