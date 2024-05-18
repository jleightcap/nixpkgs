{ buildPythonPackage
, fetchPypi
, lib
, iverilog
, verilator
, gnumake
, edalize
, fastjsonschema
, pyparsing
, pyyaml
, simplesat
, ipyxact
, setuptools-scm
, pytestCheckHook
}:
buildPythonPackage rec {
  pname = "fusesoc";
  version = "2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ruYx9dDAm23jV4tw1Op+6Pe1ea1c7VWH5RzqasFsZ6E=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ edalize fastjsonschema pyparsing pyyaml simplesat ];

  pythonImportsCheck = [ "fusesoc" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # executes git clone
    "test_library_update"
    # touches network
    "test_git_provider"
    "test_github_provider"
    "test_url_provider"
  ];

  makeWrapperArgs = [ "--suffix PATH : ${lib.makeBinPath [ iverilog verilator gnumake ]}"];

  meta = with lib; {
    changelog = "https://github.com/olofk/fusesoc/releases/tag/${version}";
    homepage = "https://github.com/olofk/fusesoc";
    description = "Package manager and build abstraction tool for FPGA/ASIC development";
    maintainers = with maintainers; [ genericnerdyusername jleightcap ];
    license = licenses.bsd2;
    mainProgram = "fusesoc";
  };
}
