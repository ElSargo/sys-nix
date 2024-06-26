{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  # Bootloader.
  boot = {
    binfmt.emulatedSystems = ["wasm32-wasi" "x86_64-windows" "aarch64-linux" "x86_32-linux"];
    loader.efi.efiSysMountPoint = "/boot/efi";
    loader.grub.configurationLimit = 10;
    tmp.cleanOnBoot = true;
    initrd.secrets = {"/crypto_keyfile.bin" = null;};
    kernelPackages = pkgs.unstable.linuxPackages_latest;
  };

  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/configuration.nix
  #////////////////////////////////////////////////////////////////////
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #////////////////////////////////////////////////////////////////////
  # From /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".device = "/dev/disk/by-uuid/4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064";
  boot.initrd.luks.devices."luks-4955bc2c-1e9b-4a8b-ab6d-125ca5b3e064".keyFile = "/crypto_keyfile.bin";

  # Do not modify this section, It was generated by ‘nixos-generate-config’
  # and may be overwritten by future invocations.  Please make changes
  # to /etc/nixos/configuration.nix instead.
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/74a2b8ac-3e60-4b09-800e-844698e161fe";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-bc0294ed-e2cf-442c-9341-86b0777f1c6c".device = "/dev/disk/by-uuid/bc0294ed-e2cf-442c-9341-86b0777f1c6c";

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/6624-CE14";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/9241452f-368d-4e95-99cc-7ec8654c13a1";}];

  system.stateVersion = "23.11";
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  #////////////////////////////////////////////////////////////////////
  # End of /etc/nixos/hardware-configuration.nix
  #////////////////////////////////////////////////////////////////////
}
