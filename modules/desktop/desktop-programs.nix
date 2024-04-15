{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        obsidian
        # libreoffice
        apostrophe
        thunderbird
        psst
        nextcloud-client
      ];
    })
  ];
}
