{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      programs.wezterm.enable = true;
      programs.wezterm.extraConfig =
        #lua
        ''
          config.font = wezterm.font 'JetbrainsMono Nerd Font'
        '';
    })
  ];
}
