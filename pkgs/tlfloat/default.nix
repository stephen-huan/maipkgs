{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  # see https://github.com/shibatch/sleef/blob/master/Configure.cmake
  version = "1.15.0";
  pname = "tlfloat";

  src = fetchFromGitHub {
    owner = "shibatch";
    repo = "tlfloat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ryxbtFwmUD2FfDMEohwuGAYTgGNqyTUK/J38Of2Fx9U=";
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "C++ template library for floating point operations";
    homepage = "https://shibatch.github.io/tlfloat-doxygen/";
    license = licenses.boost;
    maintainers = with maintainers; [ stephen-huan ];
  };
})
