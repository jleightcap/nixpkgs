{
  stdenv,
  lib,
  python3,
  openssl,
  fetchzip,
}:
stdenv.mkDerivation (prev: {
  pname = "librandombytes";
  version = "20240318";

  src = fetchzip {
    url = "https://randombytes.cr.yp.to/librandombytes-${prev.version}.tar.gz";
    hash = "sha256-LE8iWw7FxckPREyqefgKtslD6CPDsL7VsfHScQ6JmLs=";
  };

  # Needs an empty list for compatibility with the custom configure script: it doesn't check for any flags
  configurePlatforms = [ ];

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

  patches = [ ./cross.patch ];

  nativeBuildInputs = [
    openssl
    python3
  ];

  buildInputs = [ openssl ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';
})
