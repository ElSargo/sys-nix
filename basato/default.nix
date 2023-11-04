{ config, lib, modulesPath, pkgs, ... }: {
  # networking.defaultGateway = "192.168.1.200";
  networking.hostName = "Basato"; # Define your hostname.
  services.acpid.enable = true;
  # Bootloader.
  # services.undervolt.enable = true;
  boot = {
    # tmp.useTmpfs = true;
    # binfmt.emulatedSystems = [ "wasm32-wasi" "x86_64-windows" "aarch64-linux" ];
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    # kernelPackages = pkgs.unstable.linuxPackages_xanmod_latest;
    kernelPackages = pkgs.unstable.linuxPackages_zen;
    kernelParams = [ "i915.force_probe=46a6" ];
  };
  services.fprintd = { enable = true; };
  nix.settings.system-features =
    [ "gccarch-alderlake" "kvm" "nixos-test" "big-parallel" ];
  services.xserver.videoDrivers = [ "intel" "modsetting" ];
  services.xserver.deviceSection = ''
    Option "DRI" "3"   
  '';
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    driSupport = true;
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
      intel-ocl
      intel-compute-runtime
    ];
  };

  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/configuration.nix
  #////////////////////////////////////////////////////////////////////
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usb_storage"
    "usbhid"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  boot.kernelModules = [ "kvm-intel" "acpi_ec" "ec_sys" "msi-ec" ];
  boot.extraModulePackages =
    let msi-ec = config.boot.kernelPackages.callPackage ./msi-ec-patch.nix { };
    in [ msi-ec ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ab032e3a-09d1-43eb-85df-1b6ea66d99eb";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDFD-8F0E";
    fsType = "vfat";
  };

  # swapDevices =
  #   [{ device = "/dev/disk/by-uuid/05609abd-53d1-4a7e-a6c2-6b25e80867a3"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  #////////////////////////////////////////////////////////////////////
  # End of /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
}
