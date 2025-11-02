{ lib
, stdenvNoCC
, fetchzip
, boost183
, tbb_2022
, blas
, lapack
, metis
, zlib
, fftw
, hdf5_1_10
, gsl
, cgal
}:

let
  os = "Ubuntu24.04";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hlibpro";
  version = "3.2";

  src = fetchzip {
    url = "https://www.hlibpro.com/archives/${finalAttrs.version}"
      + "/hlibpro-${finalAttrs.version}-${os}.tgz";
    hash = "sha256-WjvIhLMNP0Svsrd+vAsanN9xMiLuG2yCKfTWvDsj6GA=";
  };

  # `hpro-config --cflags --lflags`
  propagatedBuildInputs = [
    boost183
    tbb_2022
    blas
    lapack
    metis
    zlib
    fftw
    hdf5_1_10
    gsl
    cgal
  ];

  outputs = [ "out" "dev" "bin" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $bin/bin
    cp -r bin -T $bin/bin
    mkdir -p $dev/include
    cp -r include -T $dev/include
    mkdir -p $out/lib
    cp -r lib -T $out/lib

    runHook postInstall
  '';

  meta = with lib; {
    description = "Library implementing algorithms for Hierarchical matrices";
    homepage = "https://hlibpro.com/";
    downloadPage = "https://www.hlibpro.com/download/";
    changelog = "https://www.hlibpro.com/news/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "hpro-config";
    outputsToInstall = [ "out" ];
    maintainers = with maintainers; [ stephen-huan ];
  };
})
