{
  buildPythonPackage,
  fetchFromSourcehut,
  setuptools-rust,
  cargo,
  llvmPackages,
  libxml2,
  zlib,
  rustc,
  rustPlatform,
  lib,
}:

buildPythonPackage rec {
  pname = "verilogae";
  version = "0.9-beta-8";

  src = fetchFromSourcehut {
    owner = "~dspom";
    repo = "OpenVAF";
    rev = "b800153e84a8a640b07048d580fabafc25bbc841";
    hash = "sha256-NKiJrXnxwghNYtKL4s3YjvQd/r3QWe5saCYp4N4aQ8w=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "salsa-0.17.0-pre.2" = "sha256-6GssvV76lFr5OzAUekz2h6f82Tn7usz5E8MSZ5DmgJw=";
    };
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustc
    llvmPackages.llvm.dev
    llvmPackages.clang
    setuptools-rust
  ];

  pythonImportsCheck = [ "verilogae" ];

  meta = {
    description = "Verilog-A tool useful for compact model parameter extraction";
    homepage = "https://man.sr.ht/~dspom/openvaf_doc/verilogae/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      jasonodoom
      jleightcap
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
  };
}
