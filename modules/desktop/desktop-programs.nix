{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        unstable.obsidian
      ];
    })
  ];
}
