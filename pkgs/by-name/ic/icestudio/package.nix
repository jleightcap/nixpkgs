{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nwjs,
  makeWrapper,
  fetchzip,
  python3,
}:

let
  version = "0.12";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "v${version}";
    hash = "sha256-LjkWje7u7IG9gMrXi6nfHXzD8ZIxm+gybh5+/Sn4PkY=";
  };

  collections = fetchzip {
    url = "https://github.com/FPGAwars/collection-default/archive/v0.4.1.zip";
    hash = "sha256-IgVqQnXY9IYax3m6ycuS4TdLEgqLgyMmtRy40kfjT34=";
  };

  app = buildNpmPackage {
    pname = "icestudio-app";
    inherit version src;
    sourceRoot = "${src.name}/app";
    npmDepsHash = "sha256-wrJ5VEt97y1k7MnaqOYfktw/xO69qdoEBbKMsd20MzY=";
    dontNpmBuild = true;
    installPhase = ''
      cat <<EOF> buildinfo.json
        {"ts":"-nixos"}
      EOF

      cp -rv ${collections} resources/collection/

      cp -rv . $out
    '';
  };
in

stdenv.mkDerivation rec {
  inherit version src;
  pname = "icestudio";

  installPhase = ''
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags ${app} --prefix PATH : "${python3}/bin"
  '';

  nativeBuildInputs = [
    nwjs
    makeWrapper
  ];

  buildInputs = [
    python3
  ];

  meta = with lib; {
    description = "Snowflake: Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "icestudio";
    platforms = platforms.all;
  };
}
