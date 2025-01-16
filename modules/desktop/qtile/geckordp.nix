ps:
ps.buildPythonPackage rec {
  pname = "geckordp";
  version = "1.0.3";
  pyproject = true;
  src = ps.fetchPypi {
    inherit pname version;
    sha256 = "sha256-MzoV0usoQBnGMj4kNv/IUOdiEp+2R7GerNuNZQBkyNw=";
  };
  doCheck = false;
  buildInputs = with ps; [hatchling hatch-fancy-pypi-readme psutil jmespath];

  prePatch = ''
    echo MIT > license
  '';
}
