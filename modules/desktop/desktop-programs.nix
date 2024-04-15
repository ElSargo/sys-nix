{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        obsidain
        # libreoffice
        apostrophe
        thunderbird
        psst
        nextcloud-client
      ];
    })
  ];
}
