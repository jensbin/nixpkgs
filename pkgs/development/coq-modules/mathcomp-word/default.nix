{
  fetchurl,
  coq,
  mkCoqDerivation,
  mathcomp,
  stdlib,
  lib,
  version ? null,
}:

let
  namePrefix = [
    "coq"
    "mathcomp"
  ];
  pname = "word";
  fetcher =
    {
      domain,
      owner,
      repo,
      rev,
      sha256 ? null,
      ...
    }:
    let
      prefix = "https://${domain}/${owner}/${repo}/";
    in
    if sha256 == null then
      fetchTarball { url = "${prefix}archive/refs/heads/${rev}.tar.gz"; }
    else
      fetchurl {
        url = "${prefix}releases/download/${rev}/${
          lib.concatStringsSep "-" (namePrefix ++ [ pname ])
        }-${rev}.tbz";
        inherit sha256;
      };
in

mkCoqDerivation {
  inherit namePrefix pname fetcher;
  owner = "jasmin-lang";
  repo = "coqword";
  useDune = true;

  releaseRev = v: "v${v}";

  release."3.2".sha256 = "sha256-4HOFFQzKbHIq+ktjJaS5b2Qr8WL1eQ26YxF4vt1FdWM=";
  release."3.1".sha256 = "sha256-qQHis6554sG7NpCpWhT2wvelnxsrbEPVNv3fpxwxHMU=";
  release."3.0".sha256 = "sha256-xEgx5HHDOimOJbNMtIVf/KG3XBemOS9XwoCoW6btyJ4=";
  release."2.4".sha256 = "sha256-OG99PfjhtKikxM9aBKRsej1gTo1O/llAdXdiiyjZf2Q=";
  release."2.3".sha256 = "sha256-whU1yvFFuxpwQutW41B/WBg5DrVZJW/Do/GuHtzuI3U=";
  release."2.2".sha256 = "sha256-8BB6SToCrMZTtU78t2K+aExuxk9O1lCqVQaa8wabSm8=";
  release."2.1".sha256 = "sha256-895gZzwwX8hN9UUQRhcgRlphHANka9R0PRotfmSEelA=";
  release."2.0".sha256 = "sha256-ySg3AviGGY5jXqqn1cP6lTw3aS5DhawXEwNUgj7pIjA=";

  inherit version;
  defaultVersion =
    let
      case = coq: mc: out: {
        cases = [
          coq
          mc
        ];
        inherit out;
      };
    in
    with lib.versions;
    lib.switch
      [ coq.coq-version mathcomp.version ]
      [
        (case (range "8.16" "9.1") (isGe "2.0") "3.2")
        (case (range "8.12" "8.20") (range "1.12" "1.19") "2.4")
      ]
      null;

  propagatedBuildInputs = [
    mathcomp.algebra
    mathcomp.ssreflect
    mathcomp.fingroup
    stdlib
  ];

  meta = with lib; {
    description = "Yet Another Coq Library on Machine Words";
    maintainers = [ maintainers.vbgl ];
    license = licenses.mit;
  };
}
