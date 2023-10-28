{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
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
  users.users.sargo.extraGroups = [ "libvirtd" ];
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
