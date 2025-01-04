{pkgs, ...}: {
  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wf-shell
      wayfire-plugins-extra
    ];
  };

  xdg.portal = {enable = true;};

  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "wayfire";
        user = "sargo";
      };

      default_session.command = "agreety --cmd $SHELL";
    };
  };

  environment.systemPackages = with pkgs; [swayosd swaynotificationcenter];
}
