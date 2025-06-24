{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, fftw
, mpfr
, openssl
, tlfloat
, enableStatic ? stdenv.hostPlatform.isStatic
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.9.0";
  pname = "sleef";

  src = fetchFromGitHub {
    owner = "shibatch";
    repo = "sleef";
    tag = finalAttrs.version;
    hash = "sha256-0y/pRcxJmd+w9lbsVcjumjV5lQmpnmgfsMJPMCGpRm8=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ tlfloat ];

  cmakeFlags = [
    (lib.strings.cmakeBool "SLEEF_BUILD_INLINE_HEADERS" true)
    (lib.strings.cmakeBool "BUILD_SHARED_LIBS" (!enableStatic))
  ];

  strictDeps = true;

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
