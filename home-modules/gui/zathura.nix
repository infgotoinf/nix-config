{
  programs.zathura = {
    enable = true;
    options = {
      font = "monospace normal 12";
    };
    mappings = {
      D = "toggle_page_mode";
      "<C-i>" = "recolor";
      KPEqual = "adjust_window best_fit";
      "<C-k>" = "navigate previous";
      "<C-j>" = "navigate next";
    };
  };
}
