{
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };
  users.users.sargo.extraGroups = ["audio"];
  hardware.pulseaudio.enable = false;
}
