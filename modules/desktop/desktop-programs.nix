{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        # libreoffice
        apostrophe
        thunderbird
        psst
        nextcloud-client
      ];
    })
  ];
}
