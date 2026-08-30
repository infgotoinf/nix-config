{ pkgs, config, ... }:
{
  programs.htop = {
    enable = true;
    package = pkgs.htop-vim;
    settings = {
      fields = with config.lib.htop.fields; [
        PID
        USER
        PRIORITY
        NICE
        M_SIZE
        M_RESIDENT
        M_SHARE
        STATE
        PERCENT_CPU
        PERCENT_MEM
        TIME
        COMM
      ];
      hide_kernel_threads = 1;
      hide_userland_threads = 1;
      hide_running_in_container = 0;
      shadow_other_users = 0;
      show_thread_names = 0;
      show_program_path = 0;
      highlight_base_name = 1;
      highlight_deleted_exe = 1;
      shadow_distribution_path_prefix = 0;
      highlight_megabytes = 1;
      highlight_threads = 1;
      highlight_changes = 1;
      highlight_changes_delay_secs = 5;
      find_comm_in_cmdline = 1;
      strip_exe_from_cmdline = 1;
      show_merged_command = 0;
      header_margin = 1;
      screen_tabs = 1;
      detailed_cpu_time = 0;
      cpu_count_from_one = 1;
      show_cpu_usage = 1;
      show_cpu_frequency = 0;
      show_cpu_temperature = 1;
      degree_fahrenheit = 0;
      show_cached_memory = 1;
      update_process_names = 0;
      account_guest_in_cpu_meter = 0;
      color_scheme = 0;
      enable_mouse = 0;
      delay = 10;
      hide_function_bar = 0;
      header_layout = "two_50_50";
      tree_view = 1;
      sort_key = 46;
      tree_sort_key = 0;
      sort_direction = -1;
      tree_sort_direction = 1;
      tree_view_always_by_pid = 1;
      all_branches_collapsed = 0;
    } // (with config.lib.htop; leftMeters [
        (bar "LeftCPUs2")
        (bar "MemorySwap")
        (bar "LoadAverage")
        (text "NetworkIO")
        (text "DiskIO")
        (text "Tasks")
    ]) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs2")
        (bar "GPU")
        (text "CPU")
    ]);
  };
}
