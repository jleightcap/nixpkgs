{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "icestudio";
  version = "0.12";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "icestudio";
    rev = "v${version}";
    hash = "sha256-LjkWje7u7IG9gMrXi6nfHXzD8ZIxm+gybh5+/Sn4PkY=";
  };

  meta = with lib; {
    description = "Snowflake: Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    mainProgram = "icestudio";
    platforms = platforms.all;
  };
}
