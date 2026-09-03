{
  programs.zathura = {
    enable = true;
    options = {
      font = "monospace normal 12";
    };
    mappings = {
      D = "toggle_page_mode";
      "<C-i>" = "recolor";
      "<C-k>" = "scroll full-up";
      "<C-j>" = "scroll full-down";
    };
  };
}
