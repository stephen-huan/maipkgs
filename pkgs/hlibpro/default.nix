{ lib
, stdenv
, fetchzip
}:

let
  os = "Ubuntu24.04";
in
stdenv.mkDerivation rec {
  pname = "hlibpro";
  version = "3.1.2";

  src = fetchzip {
    url = "https://www.hlibpro.com/archives/${version}"
      + "/hlibpro-${version}-${os}.tgz";
    hash = "sha256-3+ZhN6AyR1P2ykIFwr4IOucdWSashkkZS0lVq1v0sMs=";
  };

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
}
