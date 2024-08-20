{
  buildPythonPackage,
  fetchurl,
  lib,
  python,
  stdenv,
  unzip,
}:

buildPythonPackage rec {
  pname = "verilogae";
  version = "1.0.0";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/aa/a6/9daea00745844faba44c2917c66838adfc315269f38518ecca49e6eb5fb5/verilogae-1.0.0-cp311-cp311-manylinux_2_17_x86_64.manylinux2014_x86_64.whl";
    hash = "sha256-QsEVq/4c44xCkovOhXOj8Zh6rp4Ipq+NGjbTW25Fd6E=";
  };

  format = "other";

  unpackPhase = ''
    tmp_dir=$(mktemp -d)
    mkdir -p $out/${python.sitePackages}
    ${unzip}/bin/unzip $src -d $tmp_dir
    mv $tmp_dir/* $out/${python.sitePackages}
  '';

  installCheckPhase = ''
    export PYTHONPATH="$out/${python.sitePackages}:$PYTHONPATH"
  '';

  nativeBuildInputs = [ unzip ];

  LD_LIBRARY_PATH = "${stdenv.cc.cc.lib}/lib/";

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
