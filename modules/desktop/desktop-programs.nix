{
  home-manager.sharedModules = [
    ({pkgs, ...}: {
      home.packages = with pkgs; [
        keepassxc
        inlyne
        # libreoffice
        thunderbird
        nextcloud-client
      ];
    })
  ];
}
