{
  programs.vim = {
    enable = true;
    # defaultEditor = true;

    extraConfig = ''
      syntax enable
      set guicursor=n-v-c-i:block-Cursor

      set shiftwidth=2
      set tabstop=2
      set softtabstop=2
      set expandtab
      set smartindent

      set scrolloff=8

      set noswapfile
      set nobackup
      set undofile
      set undodir=~/.vim

      set incsearch

      set termguicolors
    '';
  };
}
