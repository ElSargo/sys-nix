{ config, lib, modulesPath, pkgs, ... }: {

  boot = {
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.unstable.linuxPackages_zen;
    kernelParams = [ "i8042.dumbkbd=1" ];
    kernelModules = [ "kvm-intel" "acpi_ec" "ec_sys" "msi-ec" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usb_storage"
      "usbhid"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];

    extraModulePackages = let
      msi-ec = config.boot.kernelPackages.callPackage ./msi-ec-patch.nix { };
    in [ msi-ec ];
  };

  services = {
    fprintd = { enable = true; };
    xserver.videoDrivers = [ "intel" "modsetting" ];
    xserver.deviceSection = ''
      Option "DRI" "3"   
    '';
  };

  nix.settings.system-features =
    [ "gccarch-alderlake" "kvm" "nixos-test" "big-parallel" ];

  hardware.opengl = {
    driSupport = true;
    enable = true;
    extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime ];
  };

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "ext4";
  };

  swapDevices = [{ device = "/dev/disk/by-label/Swap"; }];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDFD-8F0E";
    fsType = "vfat";
  };

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
