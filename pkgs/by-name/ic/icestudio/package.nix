{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nwjs,
}:

buildNpmPackage rec {
  pname = "icestudio";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "v${version}";
    hash = "sha256-LjkWje7u7IG9gMrXi6nfHXzD8ZIxm+gybh5+/Sn4PkY=";
  };

  preFixup = ''
    patchShebangs scripts/postInstall.sh
  '';

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
    cp ${./package.json} package.json
  '';

  npmDepsHash = "sha256-VG1vi5PDzcGjChnsZzoNlNDTLmcAN4LpHuPVmmMWavo=";

  npmFlags = [ "--legacy-peer-deps" ];

  dontNpmBuild = true;

  installPhase = ''
    npm run buildLinux64
    cp -rv dist/icestudio/linux64/* $out
  '';

  meta = with lib; {
    description = "Snowflake: Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "icestudio";
    platforms = platforms.all;
  };
}
