{ stdenv, python3, openssl, fetchzip }:
stdenv.mkDerivation (prev: {
  pname = "librandombytes";
  version = "20230919";

  src = fetchzip {
    url = "https://randombytes.cr.yp.to/librandombytes-${prev.version}.tar.gz";
    hash = "sha256-wr44x45AwEU1v4kvbmG37npUJGmRprnUtAzQvJJuPyw=";
  };

  nativeBuildInputs = [ python3 ];

  buildInputs = [ openssl ];

  preConfigure = ''
    patchShebangs configure
    patchShebangs scripts-build
  '';
   
})
