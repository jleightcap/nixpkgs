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

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]);

  patches = [ ./cross.patch ];

  nativeBuildInputs = [ python3 ];

  buildInputs = [ openssl ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  configurePlatforms = [ "aarch64" ];
})
