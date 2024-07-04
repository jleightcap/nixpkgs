{ 
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nwjs,
  makeWrapper,
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

  app = buildNpmPackage {
    pname = "icestudio-app";
    inherit version src;
    sourceRoot = "${src.name}/app";
    npmDepsHash = "sha256-wrJ5VEt97y1k7MnaqOYfktw/xO69qdoEBbKMsd20MzY=";
    dontNpmBuild = true;
    installPhase = ''
      cat <<EOF> buildinfo.json
      {"ts":":-)"}
      EOF

      cp -rv . $out
    '';
  };
in

stdenv.mkDerivation rec {
  inherit version src;
  pname = "icestudio";

  postPatch = ''
    patchShebangs scripts/postInstall.sh
    cp -r ${app}/node_modules app/
    chmod -R +w app/node_modules
  '';

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
