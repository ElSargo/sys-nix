{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        unstable.obsidian
        libreoffice
        varia
        jetbrains-toolbox
      ];
    })
  ];
}
