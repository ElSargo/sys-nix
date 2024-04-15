{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        unstable.obsidian
        # libreoffice
        apostrophe
        thunderbird
        psst
        nextcloud-client
      ];
    })
  ];
}
