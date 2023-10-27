{ pkgs, ... }: {
  environment.etc."dual-function-keys.yaml".text = ''
    TIMING:
      TAP_MILLISEC: 200
      DOUBLE_TAP_MILLISEC: 0

    MAPPINGS:
      - KEY: KEY_LEFTSHIFT
        TAP: [KEY_LEFTSHIFT, KEY_9]
        HOLD: KEY_LEFTSHIFT
      - KEY: KEY_RIGHTSHIFT
        TAP: [KEY_RIGHTSHIFT, KEY_0]
        HOLD: KEY_RIGHTSHIFT

      - KEY: KEY_LEFTALT
        TAP: [KEY_LEFTSHIFT, KEY_LEFTBRACE]
        HOLD: KEY_LEFTALT
      - KEY: KEY_RIGHTALT
        TAP: [KEY_LEFTSHIFT, KEY_RIGHTBRACE]
        HOLD: KEY_RIGHTALT

      - KEY: KEY_LEFTCTRL
        TAP: KEY_LEFTBRACE
        HOLD: KEY_LEFTCTRL
      - KEY: KEY_RIGHTCTRL
        TAP: KEY_RIGHTBRACE
        HOLD: KEY_RIGHTCTRL

      - KEY: KEY_CAPSLOCK
        TAP: KEY_ESC
        HOLD: KEY_LEFTCTRL
  '';
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.dual-function-keys ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.dual-function-keys}/bin/dual-function-keys -c /etc/dual-function-keys.yaml | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_LEFTSHIFT, KEY_RIGHTSHIFT, KEY_LEFTALT, KEY_RIGHTALT, KEY_LEFTCTRL, KEY_RIGHTCTRL, KEY_CAPSLOCK ]
    '';
  };

}
