{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, poetry-core
, poetry-dynamic-versioning
, pytestCheckHook
, pythonRelaxDepsHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jsonschema2md";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-I4b8TRGTMGhts5iepJerlqTe+2OIOG/Azv91a1waZqc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'poetry>=1.0.0' 'poetry-core' \
  '';

  nativeBuildInputs = [
    poetry-core
    poetry-dynamic-versioning
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "poetry-dynamic-versioning"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
  ];

  pythonImportsCheck = [
    "jsonschema2md"
  ];

  meta = {
    description = "JSON schema validator for Python";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jleightcap ];
  };
}
