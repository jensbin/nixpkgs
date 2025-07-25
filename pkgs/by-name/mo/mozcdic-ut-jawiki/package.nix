{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "mozcdic-ut-jawiki";
  version = "0-unstable-2024-10-12";

  src = fetchFromGitHub {
    owner = "utuhiro78";
    repo = "mozcdic-ut-jawiki";
    rev = "a91b76a05c4187420e46ead1cc70c2267148004b";
    hash = "sha256-EuMxFSiwSFkcpetsQpuQU6yjX4BhSmS1LbVuLacw4w0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dt $out mozcdic-ut-jawiki.txt.tar.bz2

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Dictionary generated from the Japanese Wikipedia for Mozc";
    homepage = "https://github.com/utuhiro78/mozcdic-ut-jawiki";
    license = with lib.licenses; [
      asl20
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
    # this does not need to be separately built
    # it only provides some zip files
    hydraPlatforms = [ ];
  };
}
