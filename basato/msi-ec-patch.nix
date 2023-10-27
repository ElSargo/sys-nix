{ stdenv, lib, fetchFromGitHub, kernel, kmod }:
stdenv.mkDerivation rec {
  name = "msi_ec-${version}-${kernel.version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "BeardOverflow";
    repo = "msi-ec";
    rev = "c39fe616c24e2ff12f086dfbc34358499c13f6bf";
    sha256 = "m7xrv+FvggYHIvtysdY9M2BWL8WkE57aM7RWEmHp2m4=";
  };

  hardeningDisable = [ "pic" "format" ];                                    # 1
  nativeBuildInputs = kernel.moduleBuildDependencies;                       # 2

  patches  =[
    ./msi-ec-patch.patch
  ];

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
    "INSTALL_MOD_PATH=$(out)"                                               # 5
  ];

  meta = with lib; {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = licenses.gpl2;
    maintainers = [ maintainers.makefu ];
    platforms = platforms.linux;
  };
}

