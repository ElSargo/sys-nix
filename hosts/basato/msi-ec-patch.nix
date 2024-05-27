{
  stdenv,
  lib,
  fetchFromGitHub,
  kernel,
}:
stdenv.mkDerivation rec {
  name = "msi_ec-${version}-${kernel.version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "8632888bec84724f3521261286ccf4a9f9f56f7d";
    sha256 = "sha256-yDDZUKD8r6dqQg5V5DMgdumLVkLfS6DRHVXtmFJWnQ4=";
  };

  hardeningDisable = ["pic" "format"]; # 1
  nativeBuildInputs = kernel.moduleBuildDependencies; # 2

  patches = [./msi-ec-patch.patch];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}" # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" # 4
    "INSTALL_MOD_PATH=$(out)" # 5
  ];

  meta = with lib; {
    description = "MSI laptop ec support";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
