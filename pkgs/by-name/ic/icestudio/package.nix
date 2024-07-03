{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nwjs,
  makeWrapper,
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
      cp -rv . $out
    '';
  };
in

stdenv.mkDerivation rec {
  inherit version src;
  pname = "icestudio";

  postPatch = ''
    # cp ${./package-lock.json} package-lock.json
    # cp ${./package.json} package.json
    patchShebangs scripts/postInstall.sh
    cp -r ${app}/node_modules app/
    chmod -R +w app/node_modules
  '';

  # patches = [ ./dont-download-stuff.patch ];

  # npmDepsHash = "sha256-nYAFx16yOhxKcxLqBJDDUu1/m7l1Lfn8t1lg9eCk118=";

  # npmFlags = [
  # "--legacy-peer-deps"
  # "--loglevel=verbose"
  # ];

  # dontNpmBuild = true;

  installPhase = ''
    # npm run buildLinux64
    # cp -rv dist/icestudio/linux64/* $out
    makeWrapper ${nwjs}/bin/nw $out/bin/${pname} --add-flags ${app}
  '';

  nativeBuildInputs = [
    nwjs
    makeWrapper
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
