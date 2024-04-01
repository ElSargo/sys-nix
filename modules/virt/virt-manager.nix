{
  pkgs,
  config,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;

    onShutdown = "suspend";
    onBoot = "ignore";

    qemu = {
      package = pkgs.qemu_kvm;
      ovmf.enable = true;
      ovmf.packages = [pkgs.OVMFFull.fd];
      swtpm.enable = true;
      runAsRoot = false;
    };
  };

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source =
        config.virtualisation.libvirtd.qemu.package
        + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source =
        config.virtualisation.libvirtd.qemu.package
        + "/share/qemu/edk2-i386-vars.fd";
    };
  };
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-vdagent
    spice-protocol
    win-virtio
    win-spice
    libGL
    libGLU
  ];
  users.users.sargo.extraGroups = ["libvirtd"];
  programs.dconf = {
    enable = true;
    # For home manager
    # settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };
  };
}
