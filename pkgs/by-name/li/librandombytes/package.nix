{ stdenv, python3, openssl }:
stdenv.mkDerivation rec {
  pname = "librandombytes";
  version = "20230919";

  src = fetchzip {
    url = "https://randombytes.cr.yp.to/librandombytes-${version}.tar.gz";
    hash = "sha256-wr44x45AwEU1v4kvbmG37npUJGmRprnUtAzQvJJuPyw=";
  };

  nativeBuildInputs = [ python3 ];

  buildInputs = [ openssl ];

  configurePhase = ''
    patchShebangs configure
    patchShebangs scripts-build
    ./configure --prefix=${placeholder "out"}
  '';
}
