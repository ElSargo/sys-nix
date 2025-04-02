{
  home-manager.sharedModules = [
    ({
      config,
      pkgs,
      ...
    }: {
      home.packages = with pkgs; [quickshell kdePackages.qtdeclarative];
      xdg.configFile."quickshell".source = config.lib.file.mkOutOfStoreSymlink "/home/sargo/sys-nix/modules/desktop/quickshell";
    })
  ];
}
