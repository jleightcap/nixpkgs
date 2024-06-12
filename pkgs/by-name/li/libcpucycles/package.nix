{
  stdenv,
  lib,
  python3,
  openssl,
  fetchzip,
}:
stdenv.mkDerivation (prev: {
  pname = "libcpucycles";
  version = "20240318";

  src = fetchzip {
    url = "https://cpucycles.cr.yp.to/libcpucycles-${prev.version}.tar.gz";
    hash = "sha256-Fb73EOHGgEehZJwTCtCG12xwyiqtDXFs9eFDsHBQiDo=";
  };

  # NOTE: default "fortify" sets CFLAGS += -O2 -D_FORTIFY_SOURCE=2
  # since librandombytes expects -O1, disably the fortify hardening and manually set FORTIFY_SOURCE
  hardeningDisable = [ "fortify" ];
  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]
    ++ [
      "-D_FORTIFY_SOURCE=2"
      "-O1"
    ]
  );

  # patches = [ ./cross.patch ];

  nativeBuildInputs = [
    openssl
    python3
  ];

  buildInputs = [ openssl ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  # TODO: this should be a variable, if not present, we get:
  # ValueError: unrecognized argument --build=x86_64-unknown-linux-gnu
  configurePlatforms = [ "" ];

  meta = {
    homepage = "https://cpucycles.cr.yp.to/";
    description = "Microlibrary for counting CPU cycles";
    changelog = "https://cpucycles.cr.yp.to/download.html";
    license = with lib.licenses; [
      # Upstream specifies the public domain licenses with the terms here https://cr.yp.to/spdx.html
      publicDomain
      cc0
      bsd0
      mit
      mit0
    ];
    maintainers = with lib.maintainers; [
      kiike
      imadnyc
      jleightcap
    ];
    # fill in unix or linux?
    platforms = with lib; [ ];
  };

})
