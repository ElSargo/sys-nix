{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  boot = {
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    kernelPackages = with pkgs; linuxPackagesFor linuxPackages_cachyos;
    kernelParams = ["i8042.dumbkbd=1"];
    kernelModules = ["kvm-intel" "acpi_ec" "ec_sys" "msi-ec"];

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
      msi-ec = config.boot.kernelPackages.msi-ec;
    in [msi-ec];
  };

  hardware.enableAllFirmware = true;
  environment.systemPackages = with pkgs; [sof-firmware];

  services = {
    fprintd = {enable = false;};
    xserver.videoDrivers = ["intel" "modsetting"];
    xserver.deviceSection = ''
      Option "DRI" "3"
    '';
  };

  nix.settings.system-features = ["gccarch-alderlake" "kvm" "nixos-test" "big-parallel"];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [intel-media-driver intel-compute-runtime];
  };

  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/DDFD-8F0E";
    fsType = "vfat";
  };
  fileSystems."/" = {
    device = "/dev/disk/by-label/NixOS";
    fsType = "ext4";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
    };
  };

  networking.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.stateVersion = "23.11";
}
