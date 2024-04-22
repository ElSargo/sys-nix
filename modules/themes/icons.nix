{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gtk3,
  jdupes,
  hicolor-icon-theme,
}:
stdenvNoCC.mkDerivation rec {
  pname = "more-waita-theme";
  version = "v45";

  src = fetchFromGitHub {
    owner = "somepaulo";
    repo = "MoreWaita";
    rev = version;
    hash = "sha256-UtwigqJjkin53Wg3PU14Rde6V42eKhmP26a3fDpbJ4Y=";
  };

  nativeBuildInputs = [gtk3 jdupes];

  propagatedBuildInputs = [hicolor-icon-theme];

  dontDropIconThemeCache = true;

  # These fixup steps are slow and unnecessary.
  dontPatchELF = true;
  dontRewriteSymlinks = true;

  installPhase = ''
    runHook preInstall

    patchShebangs install.sh
    mkdir -p $out/share/icons
    ./install.sh -a -d $out/share/icons
    jdupes -l -r $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "An Adwaita styled companion icon theme with extra icons for popular apps to fit with Gnome Shell's original icons.";
    homepage = "https://github.com/somepaulo/MoreWaita";
    changelog = "https://github.com/vinceliuice/Tela-icon-theme/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    # darwin systems use case-insensitive filesystems that cause hash mismatches
    platforms = subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [];
  };
}
