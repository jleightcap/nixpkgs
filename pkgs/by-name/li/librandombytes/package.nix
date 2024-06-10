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
  # TODO: Why is not stripped?
  # TODO: why do we need Qunused-arguments for clang?
  # TODO: build with clang
  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.cc.isClang [ "-Qunused-arguments" ]);

  # TODO: submit to upstream
  # TODO: clean up
  patches = [ ./cross.patch ];

  nativeBuildInputs = [ python3 ];

  buildInputs = [ openssl ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';

  # TODO: this should be a variable, if not present, we get:
  # ValueError: unrecognized argument --build=x86_64-unknown-linux-gnu
  configurePlatforms = [ "aarch64" ];
})
