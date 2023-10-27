{ pkgs, ... }: {
  services = {
    thermald = {
      enable = true;
      package = pkgs.thermald;
    };
    auto-cpufreq = {
      enable = true;
      settings = {
        # settings for when connected to a power source
        charger = {
          governor = "performance";
          scaling_min_freq = 800000; # kHz
          scaling_max_freq = 4700000; # kHz
          turbo = "auto";
        };
        battery = {
          governor = "powersave";
          scaling_min_freq = 400000; # kHz
          scaling_max_freq = 2000000; # kHz
          turbo = "auto";
        };
      };
    };
    tlp = {
      enable = true;
      settings = {
        CPU_DRIVER_OPMODE_ON_AC = ""; # "active";
        CPU_DRIVER_OPMODE_ON_BAT = ""; # "active";
        CPU_SCALING_GOVERNOR_ON_AC = ""; # "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = ""; # "powersave";
        CPU_SCALING_MIN_FREQ_ON_AC = ""; # 0;
        CPU_SCALING_MAX_FREQ_ON_AC = ""; # 9999999;
        CPU_SCALING_MIN_FREQ_ON_BAT = ""; # 0;
        CPU_SCALING_MAX_FREQ_ON_BAT = ""; # 9999999;
        CPU_ENERGY_PERF_POLICY_ON_AC = ""; # "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = ""; # "balance_power";
        CPU_MIN_PERF_ON_AC = ""; # 0;
        CPU_MAX_PERF_ON_AC = ""; # 100;
        CPU_MIN_PERF_ON_BAT = ""; # 0;
        CPU_MAX_PERF_ON_BAT = ""; # 30;

      };
    };
    power-profiles-daemon.enable = false;
  };
}
